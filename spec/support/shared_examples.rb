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
