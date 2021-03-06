module ClientSideValidations
  module SimpleForm
    module FormBuilder

      def self.included(base)
        base.class_eval do
          def self.client_side_form_settings(options, form_helper)
            wrapper_name = options[:wrapper] || ::SimpleForm.default_wrapper
            wrapper =  ::SimpleForm.wrapper(wrapper_name)
            {
              :type => self.to_s,
              :wrapper => wrapper_name,
              :error_class => wrapper.find(:error).defaults[:class].first,
              :error_tag => wrapper.find(:error).defaults[:tag],
              :wrapper_error_class => wrapper.defaults[:error_class],
              :wrapper_tag => wrapper.defaults[:tag],
              :wrapper_class => wrapper.defaults[:class].first
            }
          end
          alias_method_chain :input, :client_side_validations
        end
      end

      def input_with_client_side_validations(attribute_name, options = {}, &block)
        if options.key?(:validate)
          options[:input_html] ||= {}
          options[:input_html].merge!(:validate => options[:validate])
          options.delete(:validate)
        end

        input_without_client_side_validations(attribute_name, options, &block)
      end

    end
  end
end

SimpleForm::FormBuilder.send(:include, ClientSideValidations::SimpleForm::FormBuilder)
