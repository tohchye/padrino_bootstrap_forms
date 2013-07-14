module BootstrapForms
  class FormBuilder < ::Padrino::Helpers::FormBuilder::AbstractFormBuilder
    include BootstrapForms::Helpers::Wrappers

    delegate :content_tag, :check_box_tag, :radio_button_tag, :link_to, :capture_html, :to => :template

    def initialize(*args)
      @field_options = {}
      super(*args)
    end

    %w(select email_field file_field number_field password_field phone_field search_field telephone_field text_area text_field url_field).each do |method_name|
      define_method(method_name) do |name, *args|
        @name = name
        @field_options = args.extract_options!

        control_group_div do
          label_field << input_div do
            super(name, objectify_options(@field_options))
          end
        end
      end
    end

    def check_box(name, *args)
      @name = name
      @field_options = args.extract_options!

      control_group_div do
        input_div(false) do
          if @field_options[:label] == false || @field_options[:label] == ''
            super(name, objectify_options(@field_options)) << messages
          else
            html = super(name, objectify_options(@field_options)) << (@field_options[:label].blank? ? @name.to_s.humanize : @field_options[:label])
            html << messages
            options = { :caption => html, :class => 'checkbox' }
            options[:for] = @field_options[:id] if @field_options.include?(:id)
            label(@name, options)
          end
        end
      end
    end

    def radio_buttons(name, values = {}, opts = {})
      @name = name
      @field_options = opts

      buttons = values.map do |text, value|
        # Padrino does not stringify false values
        html = radio_button(name, objectify_options(@field_options).merge(:value => "#{value}"))
        html << text

        options = { :caption => html, :class => 'radio', :for => nil }
        label("#{name}_#{value}", options)
      end.join('')

      control_group_div do
        # Prevent "for" attribute for a non existant id
        @field_options[:id] = nil
        label_field << input_div { buttons }
      end
    end

    def collection_check_boxes(attribute, records, record_id, record_name, *args)
      @name = attribute
      @field_options = args.extract_options!

      boxes = records.map do |record|
        value = record.send(record_id)
        element_id = "#{object_model_name}_#{attribute}_#{value}"

        options = objectify_options(@field_options).merge(:value => value, :id => element_id)
        options[:checked] = "checked" if [object.send(attribute)].flatten.include?(value)

        checkbox = check_box_tag("#{object_model_name}[#{attribute}][]", options)
        checkbox << record.send(record_name)
        content_tag(:label, checkbox, :class => ['checkbox', ('inline' if @field_options[:inline])].compact.join(' '))
      end.join('')

      control_group_div do
        # Prevent "for" attribute for a non existant id
        @field_options[:id] = nil
        label_field << input_div { boxes }
      end
    end

    def collection_radio_buttons(attribute, records, record_id, record_name, *args)
      @name = attribute
      @field_options = args.extract_options!

      buttons = records.map do |record|
        value = record.send(record_id)
        element_id = "#{object_model_name}_#{attribute}_#{value}"
        options = objectify_options(@field_options).merge(:value => value, :id => element_id)
        radio = radio_button(attribute, options)
        radio << record.send(record_name)
        content_tag(:label, radio, :class => ['radio', ('inline' if @field_options[:inline])].compact.join(' '))
      end.join('')

      control_group_div do
        # Prevent "for" attribute for a non existant id
        @field_options[:id] = nil
        label_field << input_div { buttons }
      end
    end

    def uneditable_input(name, *args)
      @name = name
      @field_options = args.extract_options!
      @field_options[:id] ||= field_id(@name)
      @field_options[:label] ||= "#{field_human_name(@name)}: " # conform to Padrino's default
      @field_options[:value] ||= object.send(@name.to_sym)

      template.uneditable_input_tag(@name, @field_options)
    end

    def button(*args)
      template.bootstrap_button_tag(*args)
    end

    def submit(*args)
      template.bootstrap_submit_tag(*args)
    end

    def cancel(*args)
      template.bootstrap_cancel_tag(*args)
    end

    def actions(&block)
      content = block_given? ? capture_html(&block) : [submit, cancel].join(' ')
      content_tag(:div, content, :class => 'form-actions')
    end
  end
end
