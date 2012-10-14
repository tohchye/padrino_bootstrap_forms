require "padrino-helpers"
require 'rack/test'

v = RUBY_VERSION.split('.').map { |n| n.to_i }
require 'active_support/ordered_hash' if v[0] <= 1 and v[1] < 9

require File.expand_path(File.join(File.dirname(__FILE__), '../lib/bootstrap_forms'))

RSpec.configure do |config|   
  config.include Padrino::Helpers::OutputHelpers
  config.include Padrino::Helpers::FormatHelpers
  config.include Padrino::Helpers::TagHelpers
  config.include Padrino::Helpers::FormHelpers
  config.include BootstrapForms::Helpers::FormTagHelper
end

class Item
  attr_accessor :name
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

