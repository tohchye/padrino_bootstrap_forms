require "active_support"

module BootstrapForms
  extend ActiveSupport::Autoload

  autoload :FormBuilder
  autoload :Helpers

  def self.registered(app)
    I18n.load_path << Dir[File.join(__FILE__, "../../config/locales/*.yml")]
    app.helpers Helpers::FormHelper
    app.helpers Helpers::FormTagHelper
  end
end
