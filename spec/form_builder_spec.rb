require "spec_helper"

describe BootstrapForms::FormBuilder do
  let(:name) { :name }

  [:email, :file, :number, :password, :phone, :search, :text, :url].each do |type|
    describe "#{type}_field" do
      let(:view)  { "#{type}_field" }
      let(:field) { Hash[:type => type, :value => "sshaw", :id => "item_name", :name => "item[name]"] }
      include_examples "template engines"
    end
  end

  describe "#uneditable_input" do
    let(:view)  { "uneditable_input" }
    let(:field) { content_tag(:span, "sshaw", :id => "item_name", :class => "uneditable-input") }
    include_examples "template engines"
  end

  describe "#text_area" do
    let(:view)  { "text_area" }
    let(:field) { text_area_tag("item[name]", :id => "item_name", :value => "sshaw") }
    include_examples "template engines"
  end

  describe "#select" do
    let(:view)  { "select_field" }
    let(:field) { select_tag("item[name]", :options => %w[sshaw fofinha], :selected => "sshaw", :id => "item_name") }
    include_examples "template engines"
  end
end
