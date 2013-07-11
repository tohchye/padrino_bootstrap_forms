require 'active_support/core_ext/hash/except'

module BootstrapForms
  module Helpers
    module Wrappers
      private
      def control_group_div(&block)
        field_errors = error_string
        if @field_options[:error]
          (@field_options[:error] << ', ' << field_errors) if field_errors
        else
          @field_options[:error] = field_errors
        end

        klasses = ['control-group']
        klasses << 'error'   if @field_options[:error]
        klasses << 'info'    if @field_options[:info]
        klasses << 'success' if @field_options[:success]
        klasses << 'warning' if @field_options[:warning]
        klass = klasses.join(' ')

        content_tag(:div, block[], :class => klass)
      end

      def error_string
        if respond_to?(:object)
          errors = object.errors[@name]
          if errors.any?
            errors.map { |e|
              "#{@field_options[:label] || @name.to_s.humanize} #{e}"
            }.join(', ')
          end
        end
      end

      def input_div(&block)
        if @field_options[:append] || @field_options[:prepend]
          klasses = []
          klasses << 'input-prepend' if @field_options[:prepend]
          klasses << 'input-append' if @field_options[:append]
          klass = klasses.join(' ')
          content = content_tag(:div, addon { block[] }, :class => klass)
        else
          content = block[]
        end

        content << messages
        content_tag(:div, content, :class => 'controls')
      end

      def label_field(&block)
        if @field_options[:label] == '' || @field_options[:label] == false
          return ''
        else
          options = { :class => 'control-label' }
          # Allow for setting for to nil i.e., no for attribute. Padrino will always generate one
          options[:for] = @field_options[:id] if @field_options.include?(:id)
          options[:caption] = @field_options[:label] if @field_options[:label]

          if respond_to?(:object)
            label(@name, options, &block)
          else
            label_tag(@name, options, &block)
           end
        end
      end

      %w(help_block help_inline bootstrap_error success warning info append prepend).each do |method_name|
        define_method(method_name) do |*args|
          # Hack to avoid clashing with Padrino's error method 
          method_name = "error" if method_name == "bootstrap_error"
          return '' unless value = @field_options[method_name.to_sym]
          case method_name
          when 'help_block'
            klass = 'help-block'
          when 'append', 'prepend'
            klass = 'add-on'
          else
            klass = 'help-inline'
          end
          content_tag(:span, value, :class => klass)
        end
      end

      def messages
        [help_inline, bootstrap_error, success, warning, info, help_block].join('')
      end

      def addon(&block)
        [prepend, block[], append].join('')
      end

      def objectify_options(options)
        options.except(:label, :help_block, :help_inline, :error, :success, :warning, :info, :prepend, :append)
      end
    end
  end
end
