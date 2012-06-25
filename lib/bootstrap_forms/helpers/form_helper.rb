module BootstrapForms
  module Helpers
    module FormHelper      
      def bootstrap_form_for(record, path, options = {}, &block)
        options[:builder] = BootstrapForms::FormBuilder
        form_for(record, path, options) do |f|
          capture(f, &block)
        end
      end
    
      def bootstrap_fields_for(record, instance_or_collection = nil, &block)
        fields_for(record, instance_or_collection, &block)
      end
    end
  end
end
