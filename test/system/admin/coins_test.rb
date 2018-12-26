require "application_system_test_case"

class CoinsTest < ApplicationSystemTestCase
  setup do
    @admin_coin = admin_coins(:one)
  end

  test "visiting the index" do
    visit admin_coins_url
    assert_selector "h1", text: "Coins"
  end

  test "creating a Coin" do
    visit admin_coins_url
    click_on "New Coin"

    fill_in "Amount", with: @admin_coin.amount
    fill_in "Expense amount", with: @admin_coin.expense_amount
    fill_in "Income amount", with: @admin_coin.income_amount
    fill_in "User", with: @admin_coin.user
    click_on "Create Coin"

    assert_text "Coin was successfully created"
    click_on "Back"
  end

  test "updating a Coin" do
    visit admin_coins_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @admin_coin.amount
    fill_in "Expense amount", with: @admin_coin.expense_amount
    fill_in "Income amount", with: @admin_coin.income_amount
    fill_in "User", with: @admin_coin.user
    click_on "Update Coin"

    assert_text "Coin was successfully updated"
    click_on "Back"
  end

  test "destroying a Coin" do
    visit admin_coins_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Coin was successfully destroyed"
  end
end
