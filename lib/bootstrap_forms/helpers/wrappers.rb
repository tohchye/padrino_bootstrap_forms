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
        klasses << 'error' if @field_options[:error]
        klasses << 'success' if @field_options[:success]
        klasses << 'warning' if @field_options[:warning]
        klass = klasses.join(' ')

        content_tag(:div, (capture_html(&block) if block_given?), :class => klass)
      end

      def error_string
        if respond_to?(:object)
          errors = object.errors[@name]
          if errors.any?
            errors.map { |e|
              "#{@options[:label] || @name.to_s.humanize} #{e}"
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
          #content_tag(:div, content_tag(:div, :class => klass, &block), :class => 'controls')
          content = content_tag(:div, :class => klass, &block)
        else
          #content_tag(:div, (capture_html(&block) if block_given?), :class => 'controls')
          content = (capture_html(&block) if block_given?)
        end
        content_tag(:div, content, :class => 'controls')
      end

      def label_field(&block)
        if @field_options[:label] == '' || @field_options[:label] == false
          return ''
        else
          options = { :class => 'control-label' }
          options[:caption] = @field_options[:label] if @field_options[:label]

          if respond_to?(:object)
            label(@name, options, &block)
           else
            label_tag(@name, options, &block)
           end
        end
      end

      %w(help_inline error success warning help_block append prepend).each do |method_name|
        define_method(method_name) do |*args|
          return '' unless value = @field_options[method_name.to_sym]
          case method_name
          when 'help_block'
            element = :p
            klass = 'help-block'
          when 'append', 'prepend'
            element = :span
            klass = 'add-on'
          else
            element = :span
            klass = 'help-inline'
          end
          content_tag(element, value, :class => klass)
        end
      end

      def extras(&block)
        [prepend, (capture_html(&block) if block_given?), append, help_inline, error, success, warning, help_block].join('')
      end

      def objectify_options(options)
        options.except(:label, :help_inline, :error, :success, :warning, :help_block, :prepend, :append)
      end
    end
  end
end
