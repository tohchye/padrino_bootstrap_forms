require 'spec_helper'

describe "BootstrapForms::FormBuilder" do
  include BootstrapForms

  # Note that Padrino label() and label_tag() gen labels differently, the former always appending a ":"

  context "given a setup builder" do
    before(:each) do
      @project = Item.new
      @builder = BootstrapForms::FormBuilder.new(self, @project)
    end

    describe "with no options" do   
      describe "text_area" do
        before(:each) do
          @result = @builder.text_area "name"
        end

        it "has textarea input" do
          @result.should match /textarea/
        end
      end

      describe "uneditable_input" do
        it "generates wrapped input" do
          @builder.uneditable_input("name").should == %|<div class="control-group"><label class="control-label" for="item_name">Name: </label><div class="controls"><span class="uneditable-input"></span></div></div>|
        end

        it "allows for an id" do
          @builder.uneditable_input("name", :id => "myid").should match /<span.*id="myid"/
        end
      end

      describe "check_box" do
        it "generates wrapped input" do
          @builder.check_box("name").should == %|<div class="control-group"><div class="controls"><label class="checkbox" for="item_name"><input value="0" name="item[name]" type="hidden" /><input id="item_name" value="1" name="item[name]" type="checkbox" />Name</label></div></div>|
        end

        it "allows custom label" do
          @builder.check_box("name", :label => "custom label").should match /custom label<\/label>/
        end

        it "allows no label with :label => false " do
          @builder.check_box("name", :label => false).should_not match /<\/label>/
        end
        it "allows no label with :label => '' " do
          @builder.check_box("name", :label => '').should_not match /<\/label>/
        end
      end

      describe "radio_buttons" do
        before do
          if RUBY_VERSION < '1.9'
            @options = ActiveSupport::OrderedHash.new
            @options['One'] = '1'
n            @options['Two'] = '2'
          else
            @options = {'One' => '1', 'Two' => '2'}
          end
        end

        it "doesn't use field_options from previously generated field" do
          @builder.text_field :name, :label => 'Heading', :help_inline => 'Inline help', :help_block => 'Block help'
          @builder.radio_buttons(:name, @options).should == %|<div class="control-group"><label class="control-label" for="item_name">Name: </label><div class="controls"><label class="radio" for="item_name_1"><input value="1" id="item_name_1" name="item[name]" type="radio" />One</label><label class="radio" for="item_name_2"><input value="2" id="item_name_2" name="item[name]" type="radio" />Two</label></div></div>|
        end

        it "sets field_options" do
          @builder.radio_buttons(:name, {"One" => "1", "Two" => "2"})
          @builder.instance_variable_get("@field_options").should == {:error => nil}
        end

        it "generates wrapped input" do
          @builder.radio_buttons(:name, @options).should == %|<div class="control-group"><label class="control-label" for="item_name">Name: </label><div class="controls"><label class="radio" for="item_name_1"><input value="1" id="item_name_1" name="item[name]" type="radio" />One</label><label class="radio" for="item_name_2"><input value="2" id="item_name_2" name="item[name]" type="radio" />Two</label></div></div>|
        end

        it "allows custom label" do
          @builder.radio_buttons(:name, @options, {:label => "custom label"}).should match /custom label<\/label>/
        end
      end

      # less range
      (%w{email file number password search text url }.map{|field| ["#{field}_field",field]} + [["telephone_field", "tel"], ["phone_field", "tel"]]).each do |field, type|
        describe "#{field}" do
          context "result" do
            before(:each) do
              @result = @builder.send(field, "name")
            end

            it "is wrapped" do
              @result.should match /^<div class=\"control-group\"><label class=\"control-label\" for=\"item_name\">Name: <\/label><div class=\"controls\">.*<\/div><\/div>$/
            end

            it "has an input of type: #{type}" do
              @result.should match /<input.*type=["#{type}"]/
            end
          end # result

          context "call expectations" do
            %w(control_group_div label_field input_div extras).map(&:to_sym).each do |method|
              it "calls #{method}" do
                @builder.should_receive(method).and_return("")
              end
            end

            after(:each) do
              @builder.send(field, "name")
            end
          end # call expectations

        end # field
      end # fields
    end # no options

    describe "extras" do
      context "text_field" do
        it "adds span for inline help" do
          @builder.text_field(:name, :help_inline => 'help me!').should == %|<div class="control-group"><label class="control-label" for="item_name">Name: </label><div class="controls"><input id="item_name" name="item[name]" type="text" /><span class="help-inline">help me!</span></div></div>|
        end

        it "adds help block" do
          @builder.text_field(:name, :help_block => 'help me!').should == %|<div class="control-group"><label class="control-label" for="item_name">Name: </label><div class="controls"><input id="item_name" name="item[name]" type="text" /><p class="help-block">help me!</p></div></div>|
        end

        it "adds error message and class" do
          @builder.text_field(:name, :error => 'This is an error!').should == %|<div class="control-group error"><label class="control-label" for="item_name">Name: </label><div class="controls"><input id="item_name" name="item[name]" type="text" /><span class="help-inline">This is an error!</span></div></div>|
        end

        it "adds success message and class" do
          @builder.text_field(:name, :success => 'This checked out OK').should == %|<div class="control-group success"><label class="control-label" for="item_name">Name: </label><div class="controls"><input id="item_name" name="item[name]" type="text" /><span class="help-inline">This checked out OK</span></div></div>|
        end

        it "adds warning message and class" do
          @builder.text_field(:name, :warning => 'Take a look at this...').should == %|<div class="control-group warning"><label class="control-label" for="item_name">Name: </label><div class="controls"><input id="item_name" name="item[name]" type="text" /><span class="help-inline">Take a look at this...</span></div></div>|
        end

        it "prepends passed text" do
          @builder.text_field(:name, :prepend => '@').should == %|<div class="control-group"><label class="control-label" for="item_name">Name: </label><div class="controls"><div class="input-prepend"><span class="add-on">@</span><input id="item_name" name="item[name]" type="text" /></div></div></div>|
        end

        it "appends passed text" do
          @builder.text_field(:name, :append => '@').should == %|<div class="control-group"><label class="control-label" for="item_name">Name: </label><div class="controls"><div class="input-append"><input id="item_name" name="item[name]" type="text" /><span class="add-on">@</span></div></div></div>|
        end

        it "prepends and appends passed text" do
          @builder.text_field(:name, :append => '@', :prepend => '#').should == %|<div class="control-group"><label class="control-label" for="item_name">Name: </label><div class="controls"><div class="input-prepend input-append"><span class="add-on">\#</span><input id="item_name" name="item[name]" type="text" /><span class="add-on">@</span></div></div></div>|
        end
      end

       context "label option" do
        %w(select email_field file_field number_field password_field search_field text_area text_field url_field).each do |method_name|

          it "should not add a label when ''" do
            @builder.send(method_name.to_sym, 'name', :label => '').should_not match /<\/label>/
          end

          it "should not add a label when false" do
            @builder.send(method_name.to_sym, 'name', :label => false).should_not match /<\/label>/
          end
        end
      end
    end # extras

    describe "form actions" do
      context "actions" do
        it "adds additional block content" do
          @builder.actions do
            @builder.submit
          end.should == %|<div class="form-actions"><input class="btn btn-primary" value="Submit" type="submit" /></div>|
        end
      end

      context "submit" do
        it "adds btn primary class" do
          @builder.submit.should == %|<input class="btn btn-primary" value="Submit" type="submit" />|
        end

        it "allows for custom classes" do
          @builder.submit(:class => 'btn btn-large btn-success').should match /class="btn btn-large btn-success"/
        end
      end

      context "button" do
        it "adds btn primary class" do
          @builder.submit.should == %|<input class="btn btn-primary" value="Submit" type="submit" />|
        end

        it "allows for custom classes" do
          @builder.submit(:class => 'btn btn-large btn-success').should match /class="btn btn-large btn-success"/
        end
      end

      context "cancel" do
        it "creates a link with the default link" do
          @builder.should_receive(:link_to).with('Cancel', 'javascript:history.go(-1)', instance_of(Hash))
          @builder.cancel        
        end

        it "creates a link with a custom back link" do
          @builder.should_receive(:link_to).with('Cancel', '/x', instance_of(Hash))
          @builder.cancel(:back => '/x')
        end

        it "creates a link with a custom name" do
          @builder.should_receive(:link_to).with('Back', instance_of(String), instance_of(Hash))
          @builder.cancel('Back')
        end

        it "creates link with the default class" do
          @builder.should_receive(:link_to).with('Cancel', instance_of(String), :class => 'btn cancel')
          @builder.cancel
        end

        it "creates a link with custom classes" do
          @builder.should_receive(:link_to).with('Cancel', instance_of(String), :class => 'btn btn-large my-cancel')
          @builder.cancel(:class => 'btn btn-large my-cancel')
        end
      end
    end # actions
  end # setup builder
end
