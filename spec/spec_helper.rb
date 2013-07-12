require "padrino"
require "padrino-helpers"
require "rack/test"
require "bootstrap_forms"
require File.dirname(__FILE__) + "/app/app"

support = File.join(File.dirname(__FILE__), "support", "*.rb")
Dir[support].each { |path| require path }

VALIDATION_STATES = [:error, :success, :warning, :info]

module SpecHelper
  def app
    Padrino.application
  end

  def req(format, view, q = {})
    get "/#{format}/#{view}", q
    body = last_response.body
    # Only clean what looks like HTML. Makes any errors eaiser to trackdown.
    body =~ /\A\s*<\w/ ? clean(body) : body
  end

  def clean(str)
    str.gsub(/\s{2,}|\n/, "")
  end

  def control_group(klasses = nil)
    klasses = Array(klasses)
    klasses.unshift "control-group"
    content_tag(:div, :class => klasses.join(" ")) { yield }
  end
  
  def controls
    content_tag(:div, :class => "controls") { yield }
  end
  
  def build_control_group(name, field, options = {})
    message = options.keys.find { |k| VALIDATION_STATES.include?(k) }
    group_css = %w[control-group]
    group_css << message.to_s if message
    label_for = nil
    
    if Hash === field
      type  = field.delete(:type) || "text"
      fname = field.delete(:name) || "item[#{name}]"
      field[:id] ||= name
      label_for = field[:id]
      field = send("#{type}_field_tag", fname, field)
    elsif field =~ /id=["']([-\w]+)["']/
      label_for = $1
    end

    expected = control_group(message) do
      label_tag(name.to_s.titleize, :class => "control-label", :for => label_for) << controls do
        css   = []
        nodes = []

        if options[:prepend] || options[:append]
          addons = ""
          addons_css = []

          if options[:prepend]
            addons << content_tag(:span, options[:prepend], :class => "add-on")
            addons_css << "input-prepend" 
          end

          addons << field

          if options[:append]
            addons << content_tag(:span, options[:append], :class => "add-on")
            addons_css << "input-append" 
          end

          field = content_tag(:div, addons, :class => addons_css.join(" "))
        end
        
        nodes << field

        if options[:help_inline] 
          nodes << content_tag(:span, options[:help_inline], :class => "help-inline") 
        end

        if message
          nodes << content_tag(:span, options[message], :class => "help-inline") 
        end

        if options[:help_block]
          nodes << content_tag(:span, options[:help_block], :class => "help-block") 
        end

        nodes.join("")
      end
    end

    clean(expected)
  end
end

RSpec.configure do |config|
  config.include Padrino::Helpers::OutputHelpers
  config.include Padrino::Helpers::FormatHelpers
  config.include Padrino::Helpers::TagHelpers
  config.include Padrino::Helpers::FormHelpers
  config.include Rack::Test::Methods

  config.include SpecHelper
end
