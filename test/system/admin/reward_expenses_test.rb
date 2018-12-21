require "application_system_test_case"

class RewardExpensesTest < ApplicationSystemTestCase
  setup do
    @admin_reward_expense = admin_reward_expenses(:one)
  end

  test "visiting the index" do
    visit admin_reward_expenses_url
    assert_selector "h1", text: "Reward Expenses"
  end

  test "creating a Reward expense" do
    visit admin_reward_expenses_url
    click_on "New Reward Expense"

    fill_in "Aim", with: @admin_reward_expense.aim
    fill_in "Aim entity", with: @admin_reward_expense.aim_entity
    fill_in "Amount", with: @admin_reward_expense.amount
    fill_in "User", with: @admin_reward_expense.user
    click_on "Create Reward expense"

    assert_text "Reward expense was successfully created"
    click_on "Back"
  end

  test "updating a Reward expense" do
    visit admin_reward_expenses_url
    click_on "Edit", match: :first

    fill_in "Aim", with: @admin_reward_expense.aim
    fill_in "Aim entity", with: @admin_reward_expense.aim_entity
    fill_in "Amount", with: @admin_reward_expense.amount
    fill_in "User", with: @admin_reward_expense.user
    click_on "Update Reward expense"

    assert_text "Reward expense was successfully updated"
    click_on "Back"
  end

  test "destroying a Reward expense" do
    visit admin_reward_expenses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Reward expense was successfully destroyed"
  end
end
