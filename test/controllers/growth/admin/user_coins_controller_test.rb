require 'test_helper'

class Admin::UserCoinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user_coin = admin_user_coins(:one)
  end

  test "should get index" do
    get admin_user_coins_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_user_coin_url
    assert_response :success
  end

  test "should create admin_user_coin" do
    assert_difference('UserCoin.count') do
      post admin_user_coins_url, params: { admin_user_coin: { amount: @admin_user_coin.amount, expense_amount: @admin_user_coin.expense_amount, income_amount: @admin_user_coin.income_amount, user: @admin_user_coin.user } }
    end

    assert_redirected_to admin_user_coin_url(UserCoin.last)
  end

  test "should show admin_user_coin" do
    get admin_user_coin_url(@admin_user_coin)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_user_coin_url(@admin_user_coin)
    assert_response :success
  end

  test "should update admin_user_coin" do
    patch admin_user_coin_url(@admin_user_coin), params: { admin_user_coin: { amount: @admin_user_coin.amount, expense_amount: @admin_user_coin.expense_amount, income_amount: @admin_user_coin.income_amount, user: @admin_user_coin.user } }
    assert_redirected_to admin_user_coin_url(@admin_user_coin)
  end

  test "should destroy admin_user_coin" do
    assert_difference('UserCoin.count', -1) do
      delete admin_user_coin_url(@admin_user_coin)
    end

    assert_redirected_to admin_user_coins_url
  end
end
