require 'test_helper'

class Admin::CoinLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_coin_log = admin_coin_logs(:one)
  end

  test "should get index" do
    get admin_coin_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_coin_log_url
    assert_response :success
  end

  test "should create admin_coin_log" do
    assert_difference('CoinLog.count') do
      post admin_coin_logs_url, params: { admin_coin_log: { amount: @admin_coin_log.amount, source_id: @admin_coin_log.source_id, source_type: @admin_coin_log.source_type, title: @admin_coin_log.title, user: @admin_coin_log.user } }
    end

    assert_redirected_to admin_coin_log_url(CoinLog.last)
  end

  test "should show admin_coin_log" do
    get admin_coin_log_url(@admin_coin_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_coin_log_url(@admin_coin_log)
    assert_response :success
  end

  test "should update admin_coin_log" do
    patch admin_coin_log_url(@admin_coin_log), params: { admin_coin_log: { amount: @admin_coin_log.amount, source_id: @admin_coin_log.source_id, source_type: @admin_coin_log.source_type, title: @admin_coin_log.title, user: @admin_coin_log.user } }
    assert_redirected_to admin_coin_log_url(@admin_coin_log)
  end

  test "should destroy admin_coin_log" do
    assert_difference('CoinLog.count', -1) do
      delete admin_coin_log_url(@admin_coin_log)
    end

    assert_redirected_to admin_coin_logs_url
  end
end
