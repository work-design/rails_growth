require 'test_helper'

class UserCoinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_coin = user_coins(:one)
  end

  test "should get index" do
    get user_coins_url, as: :json
    assert_response :success
  end

  test "should create user_coin" do
    assert_difference('UserCoin.count') do
      post user_coins_url, params: { user_coin: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show user_coin" do
    get user_coin_url(@user_coin), as: :json
    assert_response :success
  end

  test "should update user_coin" do
    patch user_coin_url(@user_coin), params: { user_coin: {  } }, as: :json
    assert_response 200
  end

  test "should destroy user_coin" do
    assert_difference('UserCoin.count', -1) do
      delete user_coin_url(@user_coin), as: :json
    end

    assert_response 204
  end
end
