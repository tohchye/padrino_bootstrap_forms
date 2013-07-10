shared_examples "form builder" do
  let(:name) { :name }

  [:email, :number, :password, :phone, :search, :text, :url].each do |type|
    describe "#{type}_field" do
      let(:view)  { "#{type}_field" }
      let(:field) { Hash[:type => type, :value => "sshaw", :id => "item_name", :name => "item[name]"] }
      it_should_behave_like "a form field"
    end
  end

  describe "#file" do
    let(:view)  { "file_field" }
    let(:field) { file_field_tag("item[name]", :id => "item_name") }
    it_should_behave_like "a form field"
  end

  describe "#uneditable_input" do
    let(:view)  { "uneditable_input" }
    let(:field) { content_tag(:span, "sshaw", :id => "item_name", :class => "uneditable-input") }
    it_should_behave_like "a form field"
  end

  describe "#text_area" do
    let(:view)  { "text_area" }
    let(:field) { text_area_tag("item[name]", :id => "item_name", :value => "sshaw") }
    it_should_behave_like "a form field"
  end

  describe "#select" do
    let(:view)  { "select" }
    let(:field) { select_tag("item[name]", :options => %w[sshaw fofinha], :selected => "sshaw", :id => "item_name") }
    it_should_behave_like "a form field"
  end

  describe "#radio_buttons" do
    # def radio_button(name, options = {})
    #   content_tag(:label, :class => "radio", :for => "item_name") do
    #     field = hidden_field_tag("item[name]", :value => 0) <<
    #       radio_button_tag("item[name]", :id => "item_name", :value => 1)
    #     field << yield if block_given?
    #     field
    #   end
    # end

    # Need to add Hash options from view
    it "renders the field" do
      html = control_group do
        label_tag("Name", :class => "control-label", :for => nil) << controls do
          radio_button("Fofinho", "a") << radio_button("Galinho", "b")
        end
      end

      req(format, "radio_buttons").should eq clean(html)
    end
  end

  describe "#check_box" do
    def check_box
      content_tag(:label, :class => "checkbox", :for => "item_name") do
        field = hidden_field_tag("item[name]", :value => 0) <<
          check_box_tag("item[name]", :id => "item_name", :value => 1) <<
          "Name"
        field << yield if block_given?
        field
      end
    end

    it "renders the field" do
      html = control_group do
        controls { check_box }
      end

      req(format, "check_box").should eq clean(html)
    end

    [:help_block, :help_inline].each do |option|
      klass = option.to_s.tr "_", "-"

      it "renders the field using the :#{option} option" do
        html = control_group do
          controls do
            check_box { content_tag(:span, option.to_s.titleize, :class => klass) }
          end
        end

        req(format, "check_box_with_#{option}").should eq clean(html)
      end
    end

    VALIDATION_STATES.each do |state|
      it "renders the field using the :#{state} option" do
        html = control_group(state) do
          controls do
            check_box { content_tag(:span, state.to_s.titleize, :class => "help-inline") }
          end
        end

        req(format, "check_box_with_#{state}").should eq clean(html)
      end
    end
  end

  describe "#collection_check_boxes" do
    def check_box(name, value, checked = false)
      options = { :id => "item_name_#{value}", :value => value }
      options[:checked] = "checked" if checked

      content_tag(:label, :class => "checkbox") do
        check_box_tag("item[name][]", options) << name
      end
    end

    it "renders the field" do
      html = control_group do
        label_tag("Name", :class => "control-label", :for => nil) << controls do
          check_box("Fofinho", "a") << check_box("Galinho", "b")
        end
      end

      req(format, "collection_check_boxes").should eq clean(html)
    end

    it "renders the selected field as checked" do
      html = control_group do
        label_tag("Name", :class => "control-label", :for => nil) << controls do
          check_box("Fofinho", "a", true) << check_box("Galinho", "b")
        end
      end

      req(format, "collection_check_boxes_with_checked").should eq clean(html)
    end
  end

  def radio_button(name, value, checked = false)
    options = { :id => "item_name_#{value}", :value => value }
    options[:checked] = "checked" if checked
    
    content_tag(:label, :class => "radio") do
      radio_button_tag("item[name]", options) << name
    end
  end

  describe "#collection_radio_buttons" do
    it "renders the field" do
      html = control_group do
        label_tag("Name", :class => "control-label", :for => nil) << controls do
          radio_button("Fofinho", "a") << radio_button("Galinho", "b")
        end
      end

      req(format, "collection_radio_buttons").should eq clean(html)
    end

    it "renders the selected field as checked" do
      html = control_group do
        label_tag("Name", :class => "control-label", :for => nil) << controls do
          radio_button("Fofinho", "a", true) << radio_button("Galinho", "b")
        end
      end

      req(format, "collection_radio_buttons_with_checked").should eq clean(html)
    end
  end

  describe "#submit" do

  end  
end
