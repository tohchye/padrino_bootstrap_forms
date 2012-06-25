require "padrino-helpers"
require 'rack/test'
require 'active_support/ordered_hash' if RUBY_VERSION < '1.9'

require File.expand_path(File.join(File.dirname(__FILE__), '../lib/bootstrap_forms'))

RSpec.configure do |config| 
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.include Rack::Test::Methods
  config.include Padrino::Helpers::OutputHelpers
  config.include Padrino::Helpers::FormatHelpers
  config.include Padrino::Helpers::TagHelpers
  config.include Padrino::Helpers::FormHelpers
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

