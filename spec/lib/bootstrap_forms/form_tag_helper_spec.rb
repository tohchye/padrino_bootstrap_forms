require 'spec_helper'

describe "BootstrapForms::Helpers::FormTagHelper" do
  %w(check_box_tag email_field_tag file_field_tag number_field_tag password_field_tag radio_button_tag search_field_tag select_tag telephone_field_tag text_area_tag text_field_tag url_field_tag).each do |method_name|

    describe "#bootstrap_#{method_name}" do
      %w(control_group_div label_field input_div extras).each do |method|
        it "calls #{method}" do
          should_receive(method).and_return("")
        end
      end

      it "calls #{method_name}" do 
        should_receive(method_name).with(method_name, :class => "my-class")
      end     

      after { send("bootstrap_#{method_name}", method_name, :class => "my-class") }
    end
  end
end
