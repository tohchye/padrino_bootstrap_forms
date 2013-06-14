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
    slim params[:view].to_sym
  end

  get "/erb/:view" do
    erb params[:view].to_sym
  end
end

Padrino.load!
Padrino.mount("App").to('/')
