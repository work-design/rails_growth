require 'test_helper'

class Admin::AimStatisticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_aim_statistic = admin_aim_statistics(:one)
  end

  test "should get index" do
    get admin_aim_statistics_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_aim_statistic_url
    assert_response :success
  end

  test "should create admin_aim_statistic" do
    assert_difference('AimStatistic.count') do
      post admin_aim_statistics_url, params: { admin_aim_statistic: { aim_users_count: @admin_aim_statistic.aim_users_count, ip: @admin_aim_statistic.ip, serial_number: @admin_aim_statistic.serial_number, state: @admin_aim_statistic.state, user: @admin_aim_statistic.user } }
    end

    assert_redirected_to admin_aim_statistic_url(AimStatistic.last)
  end

  test "should show admin_aim_statistic" do
    get admin_aim_statistic_url(@admin_aim_statistic)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_aim_statistic_url(@admin_aim_statistic)
    assert_response :success
  end

  test "should update admin_aim_statistic" do
    patch admin_aim_statistic_url(@admin_aim_statistic), params: { admin_aim_statistic: { aim_users_count: @admin_aim_statistic.aim_users_count, ip: @admin_aim_statistic.ip, serial_number: @admin_aim_statistic.serial_number, state: @admin_aim_statistic.state, user: @admin_aim_statistic.user } }
    assert_redirected_to admin_aim_statistic_url(@admin_aim_statistic)
  end

  test "should destroy admin_aim_statistic" do
    assert_difference('AimStatistic.count', -1) do
      delete admin_aim_statistic_url(@admin_aim_statistic)
    end

    assert_redirected_to admin_aim_statistics_url
  end
end
