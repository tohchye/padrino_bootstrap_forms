require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'

module BootstrapForms
  extend ActiveSupport::Autoload

  autoload :FormBuilder
  autoload :Helpers

  def self.registered(app)
    app.helpers Helpers::FormHelper
    app.helpers Helpers::FormTagHelper
  end
end
