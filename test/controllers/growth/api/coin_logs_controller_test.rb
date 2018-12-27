require 'test_helper'

class Api::CoinLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_coin_log = api_coin_logs(:one)
  end

  test "should get index" do
    get api_coin_logs_url, as: :json
    assert_response :success
  end

  test "should create api_coin_log" do
    assert_difference('CoinLog.count') do
      post api_coin_logs_url, params: { api_coin_log: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show api_coin_log" do
    get api_coin_log_url(@api_coin_log), as: :json
    assert_response :success
  end

  test "should update api_coin_log" do
    patch api_coin_log_url(@api_coin_log), params: { api_coin_log: {  } }, as: :json
    assert_response 200
  end

  test "should destroy api_coin_log" do
    assert_difference('CoinLog.count', -1) do
      delete api_coin_log_url(@api_coin_log), as: :json
    end

    assert_response 204
  end
end
