# frozen_string_literal: true

module Api
  module Internal
    class HomeGuestsController < Api::Internal::ApplicationController
      def show
        query_str = <<~GRAPHQL
          query {
            node(id: "UmVjb3JkLTEzNDc3ODE=") {
              ... on Record {
                episode {
                  id
                  annictId
                  numberText
                }
              }
            }
          }
        GRAPHQL
      end
    end
  end
end
