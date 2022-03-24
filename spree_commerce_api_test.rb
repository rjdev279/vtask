# frozen_string_literal: true

require 'test/unit'
require_relative './spree_commerce_api'

# SpreeCommerceApiTest
class SpreeCommerceApiTest < Test::Unit::TestCase
  setup do
    @client = SpreeCommerceAPI::V2::Client.new
  end

  test 'should create cart' do
    response = @client.create_cart
    assert_equal response[:status], 201, 'response[:status] should return 201 status'
  end

  test 'should cart have access token' do
    response = @client.create_cart
    assert response[:data]['data']['attributes'].key?('token'), 'response should have token'
  end

  test 'should item add in cart' do
    response = @client.create_cart
    item_data = {
      'variant_id': '1',
      'quantity': 5,
      'public_metadata': {
        'first_item_order': true
      },
      'private_metadata': {
        'recommended_by_us': false
      }
    }
    response = @client.add_items(response[:data]['data']['attributes']['token'], item_data)
    assert_equal response[:status], 200, 'response[:status] should return 200 status'
    quantity = response[:data]['data']['attributes']['item_count']
    assert_equal quantity, 5, 'quantity should return 5 status'
  end

  test 'should not add item without token' do
    item_data = {
      'variant_id': '1',
      'quantity': 5,
      'public_metadata': {
        'first_item_order': true
      },
      'private_metadata': {
        'recommended_by_us': false
      }
    }
    token = nil
    response = @client.add_items(token, item_data)
    assert_equal response[:status], 404, 'response[:status] should return 400 status'
  end

  test 'should not add item without item_data' do
    response = @client.create_cart
    item_data = {}
    response = @client.add_items(response[:data]['data']['attributes']['token'], item_data)
    assert_equal response[:status], 404, 'response[:status] should return 400 status'
  end
end
