require "spec_helper"

describe "Bootstrap FormTagHelpers" do
  include Padrino::Helpers::AssetTagHelpers
  include BootstrapForms::Helpers::FormTagHelper

  let(:name) { :name }

  %w(email number password phone search text url).each do |type|
    describe "bootstrap_#{type}_field_tag" do
      let(:view)  { "#{type}_field_tag" }
      let(:field) { Hash[:type => type, :value => "sshaw", :name => name] }

      include_examples "template engines"
    end
  end
  
  describe "bootstrap_check_box_tag" do 
    let(:view)  { "check_box_tag" }
    let(:field) { check_box_tag(name, :value => "sshaw") }
    include_examples "template engines"
  end

  describe "bootstrap_select_tag" do
    let(:view)  { "select_field" }
    let(:field) { select_tag(name, :options => %w[sshaw fofinha], :selected => "sshaw") }
    include_examples "template engines"
  end

  describe "bootstrap_text_area" do
    let(:view)  { "text_area" }
    let(:field) { text_area_tag(name, :value => "sshaw") }
    include_examples "template engines"
  end

  describe "uneditable_input" do
    let(:view)  { "uneditable_input_tag" }
    let(:field) { content_tag(:span, "sshaw", :id => "name", :class => "uneditable-input",) }
    include_examples "template engines"
  end

  describe "buttons" do
    context "bootstrap_submit_tag" do
      it "adds btn primary class" do
        bootstrap_submit_tag.should eq %|<input class="btn btn-primary" value="Submit" type="submit" />|
      end

      it "allows for custom classes" do
        bootstrap_submit_tag(:class => "btn-large btn-success").should eq %|<input class="btn btn-large btn-success" value="Submit" type="submit" />|
      end
    end

    context "button" do
      it "adds btn primary class" do
        bootstrap_submit_tag.should == %|<input class="btn btn-primary" value="Submit" type="submit" />|
      end

      it "allows for custom classes" do
        bootstrap_submit_tag(:class => "btn-large btn-success").should match /class="btn btn-large btn-success"/
      end
    end

    context "bootstrap_cancel_tag" do
      it "creates a link with the default href" do
        bootstrap_cancel_tag.should eq %|<a class="btn cancel" href="javascript:history.go(-1)">Cancel</a>|
      end

      it "creates a link with the given back option" do
        bootstrap_cancel_tag(:back => "/x").should eq  %|<a class="btn cancel" href="/x">Cancel</a>|
      end

      it "creates a link with the given text" do
        bootstrap_cancel_tag("Back").should eq  %|<a class="btn cancel" href="javascript:history.go(-1)">Back</a>|
      end

      it "creates a link with custom classes" do
        bootstrap_cancel_tag(:class => "btn-large my-cancel").should eq %|<a class="btn btn-large my-cancel" href="javascript:history.go(-1)">Back</a>|
      end
    end
  end
end
