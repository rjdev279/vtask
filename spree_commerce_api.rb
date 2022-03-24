# frozen_string_literal: true

require 'json'
require 'faraday'

# SpreeCommerceAPI
module SpreeCommerceAPI
  module V2
    # SpreeCommerceAPI Client
    class Client
      BASE_URL = 'https://demo.spreecommerce.org'
      URI_PATTERN = '/api/v2/storefront/cart'

      def create_cart
        request('post', URI_PATTERN)
      end

      def add_items(token, item_data)
        request('post', "#{URI_PATTERN}/add_item", JSON.generate(item_data),
                token)
      end

      private

      def request(method, path, params = '', token = nil)
        response = connection(token).send(method.to_sym, path, params)
        { status: response.status, data: JSON.parse(response.body) }
      rescue StandardError => e
        { status: 408, errors: e.message }
      end

      def connection(token)
        Faraday.new(url: BASE_URL, ssl: { verify: true }) do |faraday|
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter
          faraday.headers['Content-Type'] = 'application/vnd.api+json'
          faraday.headers['X-Spree-Order-Token'] = token unless token.nil?
        end
      end
    end
  end
end
