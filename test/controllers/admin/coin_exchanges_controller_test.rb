require 'test_helper'

class Admin::CoinExchangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_coin_exchange = admin_coin_exchanges(:one)
  end

  test "should get index" do
    get admin_coin_exchanges_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_coin_exchange_url
    assert_response :success
  end

  test "should create admin_coin_exchange" do
    assert_difference('CoinExchange.count') do
      post admin_coin_exchanges_url, params: { admin_coin_exchange: { amount: @admin_coin_exchange.amount, coin_amount: @admin_coin_exchange.coin_amount, created_at: @admin_coin_exchange.created_at, done_at: @admin_coin_exchange.done_at, state: @admin_coin_exchange.state, type: @admin_coin_exchange.type, user: @admin_coin_exchange.user } }
    end

    assert_redirected_to admin_coin_exchange_url(CoinExchange.last)
  end

  test "should show admin_coin_exchange" do
    get admin_coin_exchange_url(@admin_coin_exchange)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_coin_exchange_url(@admin_coin_exchange)
    assert_response :success
  end

  test "should update admin_coin_exchange" do
    patch admin_coin_exchange_url(@admin_coin_exchange), params: { admin_coin_exchange: { amount: @admin_coin_exchange.amount, coin_amount: @admin_coin_exchange.coin_amount, created_at: @admin_coin_exchange.created_at, done_at: @admin_coin_exchange.done_at, state: @admin_coin_exchange.state, type: @admin_coin_exchange.type, user: @admin_coin_exchange.user } }
    assert_redirected_to admin_coin_exchange_url(@admin_coin_exchange)
  end

  test "should destroy admin_coin_exchange" do
    assert_difference('CoinExchange.count', -1) do
      delete admin_coin_exchange_url(@admin_coin_exchange)
    end

    assert_redirected_to admin_coin_exchanges_url
  end
end
