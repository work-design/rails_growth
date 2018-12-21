require 'test_helper'

class Admin::RewardExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_reward_expense = admin_reward_expenses(:one)
  end

  test "should get index" do
    get admin_reward_expenses_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_reward_expense_url
    assert_response :success
  end

  test "should create admin_reward_expense" do
    assert_difference('RewardExpense.count') do
      post admin_reward_expenses_url, params: { admin_reward_expense: { aim: @admin_reward_expense.aim, aim_entity: @admin_reward_expense.aim_entity, amount: @admin_reward_expense.amount, user: @admin_reward_expense.user } }
    end

    assert_redirected_to admin_reward_expense_url(RewardExpense.last)
  end

  test "should show admin_reward_expense" do
    get admin_reward_expense_url(@admin_reward_expense)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_reward_expense_url(@admin_reward_expense)
    assert_response :success
  end

  test "should update admin_reward_expense" do
    patch admin_reward_expense_url(@admin_reward_expense), params: { admin_reward_expense: { aim: @admin_reward_expense.aim, aim_entity: @admin_reward_expense.aim_entity, amount: @admin_reward_expense.amount, user: @admin_reward_expense.user } }
    assert_redirected_to admin_reward_expense_url(@admin_reward_expense)
  end

  test "should destroy admin_reward_expense" do
    assert_difference('RewardExpense.count', -1) do
      delete admin_reward_expense_url(@admin_reward_expense)
    end

    assert_redirected_to admin_reward_expenses_url
  end
end
