require "application_system_test_case"

class UserCoinsTest < ApplicationSystemTestCase
  setup do
    @admin_user_coin = admin_user_coins(:one)
  end

  test "visiting the index" do
    visit admin_user_coins_url
    assert_selector "h1", text: "User Coins"
  end

  test "creating a User coin" do
    visit admin_user_coins_url
    click_on "New User Coin"

    fill_in "Amount", with: @admin_user_coin.amount
    fill_in "Expense amount", with: @admin_user_coin.expense_amount
    fill_in "Income amount", with: @admin_user_coin.income_amount
    fill_in "User", with: @admin_user_coin.user
    click_on "Create User coin"

    assert_text "User coin was successfully created"
    click_on "Back"
  end

  test "updating a User coin" do
    visit admin_user_coins_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @admin_user_coin.amount
    fill_in "Expense amount", with: @admin_user_coin.expense_amount
    fill_in "Income amount", with: @admin_user_coin.income_amount
    fill_in "User", with: @admin_user_coin.user
    click_on "Update User coin"

    assert_text "User coin was successfully updated"
    click_on "Back"
  end

  test "destroying a User coin" do
    visit admin_user_coins_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User coin was successfully destroyed"
  end
end
