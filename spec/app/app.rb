require "rubygems" unless defined?(Gem)
require "bundler/setup"
Bundler.require(:default, "development") # Gemfile from gemspec puts dev dependencies in this group

require "ostruct"

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
    super do |k|
      k, v = k[0..1]
      v.each { |e| yield(k, e) }
    end
  end
end

class App < Padrino::Application
  register Padrino::Rendering
  register Padrino::Helpers
  register BootstrapForms

  disable :raise_errors
  disable :show_exceptions
  disable :logging

  error do
    e = env["sinatra.error"]
    "Error: #{e}\n" << e.backtrace.join("\n")
  end
  
  before do 
    @item = Item.new(:name => "sshaw")
    @builder = BootstrapForms::FormBuilder.new(self, @item)
  end
  
  get "/slim/:view" do
    slim "slim/#{params[:view]}".to_sym
  end

  get "/haml/:view" do
    haml "haml/#{params[:view]}".to_sym
  end
  
  get "/erb/:view" do
    erb "erb/#{params[:view]}".to_sym
  end
end

Padrino.load!
Padrino.mount("App").to('/')
