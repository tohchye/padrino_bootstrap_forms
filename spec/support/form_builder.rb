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
end









