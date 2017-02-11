# frozen_string_literal: true

module ResourceImageDecoratorCommon
  extend ActiveSupport::Concern

  included do
    def asin_or_copyright_text
      if copyright.present?
        messages = []
        messages << h.icon("copyright", class: "mr-zp25")
        messages << Rack::Utils.escape_html(copyright)
        h.content_tag(:span, messages.join.html_safe, class: "text-muted")
      elsif asin.present?
        h.link_to amazon_url, target: "_blank" do
          messages = []
          messages << h.icon("amazon", class: "mr-zp25")
          messages << I18n.t("messages._common.view_amazon_product")
          messages.join.html_safe
        end
      end
    end

    def image_url(field, options = {})
      h.ann_image_url(model, field, options)
    end

    private

    def amazon_url
      return asin unless asin.match?(/\A[0-9A-Z]{10}\z/)
      amazon_url_key = I18n.locale == :ja ? "AMAZON_JA_URL" : "AMAZON_EN_URL"
      "#{ENV.fetch(amazon_url_key)}/dp/#{asin}?tag=annict-22"
    end
  end
end