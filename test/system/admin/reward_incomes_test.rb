require "application_system_test_case"

class RewardIncomesTest < ApplicationSystemTestCase
  setup do
    @admin_reward_income = admin_reward_incomes(:one)
  end

  test "visiting the index" do
    visit admin_reward_incomes_url
    assert_selector "h1", text: "Reward Incomes"
  end

  test "creating a Reward income" do
    visit admin_reward_incomes_url
    click_on "New Reward Income"

    fill_in "Amount", with: @admin_reward_income.amount
    fill_in "Type", with: @admin_reward_income.type
    click_on "Create Reward income"

    assert_text "Reward income was successfully created"
    click_on "Back"
  end

  test "updating a Reward income" do
    visit admin_reward_incomes_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @admin_reward_income.amount
    fill_in "Type", with: @admin_reward_income.type
    click_on "Update Reward income"

    assert_text "Reward income was successfully updated"
    click_on "Back"
  end

  test "destroying a Reward income" do
    visit admin_reward_incomes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Reward income was successfully destroyed"
  end
end
