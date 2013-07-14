shared_examples "form tag helpers" do
  include Padrino::Helpers::AssetTagHelpers
  include BootstrapForms::Helpers::FormTagHelper

  let(:name) { :name }

  %w(email number password phone search text url).each do |type|
    describe "bootstrap_#{type}_field_tag" do
      let(:view)  { "#{type}_field_tag" }
      let(:field) { Hash[:type => type, :value => "sshaw", :name => name] }
      it_should_behave_like "a form field"
    end
  end

  describe "bootstrap_check_box_tag" do
    let(:view)  { "check_box_tag" }
    let(:field) { check_box_tag(name, :value => "sshaw", :id => "name") }
    it_should_behave_like "a form field"
  end

  describe "bootstrap_select_tag" do
    let(:view)  { "select_tag" }
    let(:field) { select_tag(name, :id => "name", :options => %w[sshaw fofinha], :selected => "sshaw") }
    it_should_behave_like "a form field"
  end

  describe "bootstrap_text_area_tag" do
    let(:view)  { "text_area_tag" }
    let(:field) { text_area_tag(name, :id => "name", :value => "sshaw") }
    it_should_behave_like "a form field"
  end

  describe "uneditable_input_tag" do
    let(:view)  { "uneditable_input_tag" }
    let(:field) { content_tag(:span, "sshaw", :class => "uneditable-input") }
    it_should_behave_like "a form field"
  end

  describe "bootstrap_submit_tag" do
    it "adds btn primary class" do
      bootstrap_submit_tag.should eq %|<input class="btn btn-primary" value="Submit" type="submit" />|
    end

    it "allows for custom classes" do
      bootstrap_submit_tag(:class => "btn-large btn-success").should eq %|<input class="btn-large btn-success" value="Submit" type="submit" />|
    end
  end

  describe "bootstrap_actions" do
    it "renders submit and cancel tags by default" do
      req(format, "bootstrap_actions").should eq %|<div class="form-actions"><input class="btn btn-primary" value="Submit" type="submit" /> <a class="btn cancel" href="javascript:history.go(-1)">Cancel</a></div>|
    end

    it "renders using content from the provided block" do
      pending "Test case fails, but correct HTML is rendered" if format == :slim
      req(format, "bootstrap_actions_with_block").should eq %|<div class="form-actions"><a class="btn cancel" href="javascript:history.go(-1)">No!</a></div>|
    end
  end

  describe "bootstrap_button_tag" do
    it "adds btn primary class" do
      bootstrap_submit_tag.should == %|<input class="btn btn-primary" value="Submit" type="submit" />|
    end

    it "allows for custom classes" do
      bootstrap_submit_tag(:class => "btn-large btn-success").should match /class="btn-large btn-success"/
    end
  end

  describe "bootstrap_cancel_tag" do
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
      bootstrap_cancel_tag(:class => "btn-large my-cancel").should eq %|<a class="btn-large my-cancel" href="javascript:history.go(-1)">Cancel</a>|
    end
  end
end
