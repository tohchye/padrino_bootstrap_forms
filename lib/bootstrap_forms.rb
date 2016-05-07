require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'

module BootstrapForms
  autoload :FormBuilder, 'bootstrap_forms/form_builder'
  autoload :Helpers, 'bootstrap_forms/helpers'

  def self.registered(app)
    app.helpers Helpers::FormHelper
    app.helpers Helpers::FormTagHelper
  end
end
