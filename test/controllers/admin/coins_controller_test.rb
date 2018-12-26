require 'test_helper'

class Admin::CoinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_coin = admin_coins(:one)
  end

  test "should get index" do
    get admin_coins_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_coin_url
    assert_response :success
  end

  test "should create admin_coin" do
    assert_difference('Coin.count') do
      post admin_coins_url, params: { admin_coin: { amount: @admin_coin.amount, expense_amount: @admin_coin.expense_amount, income_amount: @admin_coin.income_amount, user: @admin_coin.user } }
    end

    assert_redirected_to admin_coin_url(Coin.last)
  end

  test "should show admin_coin" do
    get admin_coin_url(@admin_coin)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_coin_url(@admin_coin)
    assert_response :success
  end

  test "should update admin_coin" do
    patch admin_coin_url(@admin_coin), params: { admin_coin: { amount: @admin_coin.amount, expense_amount: @admin_coin.expense_amount, income_amount: @admin_coin.income_amount, user: @admin_coin.user } }
    assert_redirected_to admin_coin_url(@admin_coin)
  end

  test "should destroy admin_coin" do
    assert_difference('Coin.count', -1) do
      delete admin_coin_url(@admin_coin)
    end

    assert_redirected_to admin_coins_url
  end
end
