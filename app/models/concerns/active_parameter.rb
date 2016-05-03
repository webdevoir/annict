# frozen_string_literal: true

module ActiveParameter
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Model

    BASIC_ATTRS = %i(controller action access_token).freeze

    attr_accessor *BASIC_ATTRS
    define_model_callbacks :initialize

    def initialize(params = {})
      @params = params
      run_callbacks :initialize do
        super @params.slice(*BASIC_ATTRS)
      end
    end

    def self.param(attr, default: nil)
      method_name = "set_default_#{attr}"

      attr_accessor attr.to_sym
      after_initialize method_name.to_sym

      define_method(method_name) do
        return send(attr) if send(attr).present?

        default_value = default.is_a?(Proc) ? default.call : default
        send("#{attr}=", (default_value.presence || @params[attr]))
      end

      private method_name
    end

    def fields_contain?(field)
      fields.blank? || fields.split(",").include?(field)
    end
  end
end
