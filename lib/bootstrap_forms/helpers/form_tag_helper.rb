module BootstrapForms
  module Helpers
    module FormTagHelper
      include BootstrapForms::Helpers::Wrappers

      %w(check_box_tag email_field_tag file_field_tag number_field_tag password_field_tag radio_button_tag search_field_tag select_tag telephone_field_tag text_area_tag text_field_tag url_field_tag).each do |method_name|
        # prefix each method with bootstrap_*
        define_method("bootstrap_#{method_name}") do |name, *args|
          @name = name
          @field_options = args.extract_options!
          @field_options[:id] ||= name

          control_group_div do
            label_field + input_div do
              extras { send(method_name.to_sym, name, objectify_options(@field_options)) }
            end
          end
        end
      end

      alias :bootstrap_phone_field_tag :bootstrap_telephone_field_tag

      def uneditable_input_tag(name, *args)
        @name = name
        @field_options = args.extract_options!
        @args = args

        control_group_div do
          label_field + input_div do
            extras do
              value = @field_options.delete(:value)
              @field_options[:class] = [@field_options[:class], 'uneditable-input'].compact.join ' '

              content_tag(:span, objectify_options(@field_options)) do
                escape_html(value)
              end
            end
          end
        end
      end

      def bootstrap_button_tag(*args)
        options = args.extract_options!
        options[:class] ||= 'btn btn-primary'

        name = args.shift || 'Submit'
        # button_tag() renders <input type="button">
        content_tag(:button, name, options)
      end

      def bootstrap_submit_tag(*args)
        options = args.extract_options!
        options[:class] ||= 'btn btn-primary'

        name = args.shift || 'Submit'
        submit_tag(name, options)
      end

      def bootstrap_cancel_tag(*args)
        options = args.extract_options!
        options[:class] ||= 'btn cancel'
        options[:back]  ||= 'javascript:history.go(-1)'

        name = args.shift || 'Cancel'
        link_to(name, options[:back], options.except(:back))
      end

      def bootstrap_actions(&block)
        content_tag(:div, :class => 'form-actions') do
          if block_given?
            capture_html(&block)
          else
            [bootstrap_submit_tag, bootstrap_cancel_tag].join(' ')
          end
        end
      end
    end
  end
end
