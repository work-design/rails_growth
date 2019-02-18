require "application_system_test_case"

class GiftsTest < ApplicationSystemTestCase
  setup do
    @admin_gift = admin_gifts(:one)
  end

  test "visiting the index" do
    visit admin_gifts_url
    assert_selector "h1", text: "Gifts"
  end

  test "creating a Gift" do
    visit admin_gifts_url
    click_on "New Gift"

    fill_in "Amount", with: @admin_gift.amount
    fill_in "Code", with: @admin_gift.code
    fill_in "Name", with: @admin_gift.name
    fill_in "Praise incomes count", with: @admin_gift.praise_incomes_count
    click_on "Create Gift"

    assert_text "Gift was successfully created"
    click_on "Back"
  end

  test "updating a Gift" do
    visit admin_gifts_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @admin_gift.amount
    fill_in "Code", with: @admin_gift.code
    fill_in "Name", with: @admin_gift.name
    fill_in "Praise incomes count", with: @admin_gift.praise_incomes_count
    click_on "Update Gift"

    assert_text "Gift was successfully updated"
    click_on "Back"
  end

  test "destroying a Gift" do
    visit admin_gifts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Gift was successfully destroyed"
  end
end
