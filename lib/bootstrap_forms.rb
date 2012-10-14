require 'active_support'

module BootstrapForms
  extend ActiveSupport::Autoload

  autoload :FormBuilder
  autoload :Helpers

  def self.registered(app)
    app.helpers Helpers::FormHelper
    app.helpers Helpers::FormTagHelper
  end
end
