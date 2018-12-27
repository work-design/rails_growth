require 'test_helper'

class Admin::RewardIncomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_reward_income = admin_reward_incomes(:one)
  end

  test "should get index" do
    get admin_reward_incomes_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_reward_income_url
    assert_response :success
  end

  test "should create admin_reward_income" do
    assert_difference('RewardIncome.count') do
      post admin_reward_incomes_url, params: { admin_reward_income: { amount: @admin_reward_income.amount, type: @admin_reward_income.type } }
    end

    assert_redirected_to admin_reward_income_url(RewardIncome.last)
  end

  test "should show admin_reward_income" do
    get admin_reward_income_url(@admin_reward_income)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_reward_income_url(@admin_reward_income)
    assert_response :success
  end

  test "should update admin_reward_income" do
    patch admin_reward_income_url(@admin_reward_income), params: { admin_reward_income: { amount: @admin_reward_income.amount, type: @admin_reward_income.type } }
    assert_redirected_to admin_reward_income_url(@admin_reward_income)
  end

  test "should destroy admin_reward_income" do
    assert_difference('RewardIncome.count', -1) do
      delete admin_reward_income_url(@admin_reward_income)
    end

    assert_redirected_to admin_reward_incomes_url
  end
end
