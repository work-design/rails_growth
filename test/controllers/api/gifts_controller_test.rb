require 'test_helper'

class Api::GiftsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_gift = api_gifts(:one)
  end

  test "should get index" do
    get api_gifts_url, as: :json
    assert_response :success
  end

  test "should create api_gift" do
    assert_difference('Gift.count') do
      post api_gifts_url, params: { api_gift: { amount: @api_gift.amount, code: @api_gift.code, name: @api_gift.name, praise_incomes_count: @api_gift.praise_incomes_count } }, as: :json
    end

    assert_response 201
  end

  test "should show api_gift" do
    get api_gift_url(@api_gift), as: :json
    assert_response :success
  end

  test "should update api_gift" do
    patch api_gift_url(@api_gift), params: { api_gift: { amount: @api_gift.amount, code: @api_gift.code, name: @api_gift.name, praise_incomes_count: @api_gift.praise_incomes_count } }, as: :json
    assert_response 200
  end

  test "should destroy api_gift" do
    assert_difference('Gift.count', -1) do
      delete api_gift_url(@api_gift), as: :json
    end

    assert_response 204
  end
end
