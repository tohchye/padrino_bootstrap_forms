require "spec_helper"

shared_examples "form builder fields" do
  it "renders the field" do
    req(format, view).should eq control_group(name, field)
  end

  [:help_inline, :help_block, :prepend, :append, :error, :success, :warning, :info].each do |option|
    it "renders the field using the :#{option} option" do
      req(format, "#{view}_with_#{option}").should eq control_group(name, field, option => option.to_s.titleize)
    end
  end
  
  it "renders the field using the :prepend, :append, and :help_inline options" do
    req(format, "#{view}_with_prepend_append_and_help_inline").should eq control_group(name, field, :prepend => "Prepend", :append => "Append", :help_inline => "Help Inline")
  end
end

shared_examples "template engines" do
  context "using erb" do
    let(:format) { :erb }
    include_examples "form builder fields"      
  end
  
  context "using haml" do
    let(:format) { :haml }
    include_examples "form builder fields"      
  end
   
  # context "using slim" do
  #   include_examples "form builder fields"
  #   let(:format) { :slim }
  # end
end

describe BootstrapForms::FormBuilder do
  let(:name) { :name }  

  [:email, :file, :number, :password, :phone, :search, :text, :url].each do |type|
    describe "#{type}_field" do
      let(:view)  { "#{type}_field" }
      let(:field) { Hash[:type => type, :value => "sshaw"] }
      include_examples "template engines"
    end
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
