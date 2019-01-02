require "application_system_test_case"

class CoinExchangesTest < ApplicationSystemTestCase
  setup do
    @admin_coin_exchange = admin_coin_exchanges(:one)
  end

  test "visiting the index" do
    visit admin_coin_exchanges_url
    assert_selector "h1", text: "Coin Exchanges"
  end

  test "creating a Coin exchange" do
    visit admin_coin_exchanges_url
    click_on "New Coin Exchange"

    fill_in "Amount", with: @admin_coin_exchange.amount
    fill_in "Coin amount", with: @admin_coin_exchange.coin_amount
    fill_in "Created at", with: @admin_coin_exchange.created_at
    fill_in "Done at", with: @admin_coin_exchange.done_at
    fill_in "State", with: @admin_coin_exchange.state
    fill_in "Type", with: @admin_coin_exchange.type
    fill_in "User", with: @admin_coin_exchange.user
    click_on "Create Coin exchange"

    assert_text "Coin exchange was successfully created"
    click_on "Back"
  end

  test "updating a Coin exchange" do
    visit admin_coin_exchanges_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @admin_coin_exchange.amount
    fill_in "Coin amount", with: @admin_coin_exchange.coin_amount
    fill_in "Created at", with: @admin_coin_exchange.created_at
    fill_in "Done at", with: @admin_coin_exchange.done_at
    fill_in "State", with: @admin_coin_exchange.state
    fill_in "Type", with: @admin_coin_exchange.type
    fill_in "User", with: @admin_coin_exchange.user
    click_on "Update Coin exchange"

    assert_text "Coin exchange was successfully updated"
    click_on "Back"
  end

  test "destroying a Coin exchange" do
    visit admin_coin_exchanges_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Coin exchange was successfully destroyed"
  end
end
