require "padrino"
require "padrino-helpers"
require "ostruct"
require "rack/test"
require "bootstrap_forms"

require File.expand_path(File.dirname(__FILE__) + '/app/app')

RSpec.configure do |config|
  config.include Padrino::Helpers::OutputHelpers
  config.include Padrino::Helpers::FormatHelpers
  config.include Padrino::Helpers::TagHelpers
  config.include Padrino::Helpers::FormHelpers
  config.include Rack::Test::Methods

  config.include Module.new {
    def req(format, view)
      get "/#{format}/#{view}"
      last_response.body
    end

    def app
      Padrino.application
    end
  }
end

RSpec::Matchers.define :have_field do |field_name, field, options = {}|
  include Padrino::Helpers::OutputHelpers
  include Padrino::Helpers::FormatHelpers
  include Padrino::Helpers::TagHelpers
  include Padrino::Helpers::FormHelpers

  #diffable    
  klass = options.keys.find { |k| [:error, :succes, :warning, :info].include?(k) }
  group_css = %w[control-group]
  group_css << klass.to_s if klass

  if Hash === field
    type = field.delete(:type) || "text"
    name = field.delete(:name) || "item[#{field_name}]"
    field[:id] ||= "item_#{field_name}"
    field = send("#{type}_field_tag", name, field)
  end
  
  expected = content_tag(:div, :class => group_css.join(" ")) do
    label_tag(field_name.to_s.titleize, :class => "control-label", :for => "item_#{field_name}") << content_tag(:div, :class => "controls") do
      if options[:prepend] || options[:append]
        css = []
        nodes = []

        if options[:prepend]
          css << "input-prepend"
          nodes << content_tag(:span, options[:prepend], :class => "add-on")
        end

        nodes << field

        if options[:append]
          css << "input-append"
          nodes << content_tag(:span, options[:append], :class => "add-on")
        end
        
        content_tag :div, nodes.join(""), :class => css.join(" ")
      #TODO: need to add klass' value here too!
      elsif options[:help_inline] || options[:help_block]
        type, text = options[:help_inline] ?
          [ "inline", options[:help_inline] ] :
          [ "block",  options[:help_block] ]
        
        field << content_tag(:span, text, :class => "help-#{type}")
      else
        field
      end
    end
  end

  match { |actual| actual == expected }

  failure_message_for_should do |actual|
    "expected #{actual.gsub(/\s{2,}/, "")} to equal #{expected}"
  end
end

class Item < OpenStruct
  def errors
    @errors ||= Errors.new
  end
end

class Errors < Hash
  def initialize
    super { |h, v| h[v] = [] }
  end

  def each
    super do |k, v|
      v.each { |e| yield(k, e) }
    end
  end
end
