require "application_system_test_case"

class CoinLogsTest < ApplicationSystemTestCase
  setup do
    @admin_coin_log = admin_coin_logs(:one)
  end

  test "visiting the index" do
    visit admin_coin_logs_url
    assert_selector "h1", text: "Coin Logs"
  end

  test "creating a Coin log" do
    visit admin_coin_logs_url
    click_on "New Coin Log"

    fill_in "Amount", with: @admin_coin_log.amount
    fill_in "Source", with: @admin_coin_log.source_id
    fill_in "Source type", with: @admin_coin_log.source_type
    fill_in "Title", with: @admin_coin_log.title
    fill_in "User", with: @admin_coin_log.user
    click_on "Create Coin log"

    assert_text "Coin log was successfully created"
    click_on "Back"
  end

  test "updating a Coin log" do
    visit admin_coin_logs_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @admin_coin_log.amount
    fill_in "Source", with: @admin_coin_log.source_id
    fill_in "Source type", with: @admin_coin_log.source_type
    fill_in "Title", with: @admin_coin_log.title
    fill_in "User", with: @admin_coin_log.user
    click_on "Update Coin log"

    assert_text "Coin log was successfully updated"
    click_on "Back"
  end

  test "destroying a Coin log" do
    visit admin_coin_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Coin log was successfully destroyed"
  end
end
