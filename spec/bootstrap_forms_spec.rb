require "spec_helper"

describe BootstrapForms do
  context "using erb" do
    let(:format) { :erb }
    include_examples "form tag helpers"
    include_examples "form builder"
  end

  context "using haml" do
    let(:format) { :haml }
    include_examples "form builder"
    include_examples "form tag helpers"
  end

  context "using slim" do
    let(:format) { :slim }
    include_examples "form tag helpers"
    include_examples "form builder"
  end
end
