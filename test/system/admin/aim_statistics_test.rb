require "application_system_test_case"

class AimStatisticsTest < ApplicationSystemTestCase
  setup do
    @admin_aim_statistic = admin_aim_statistics(:one)
  end

  test "visiting the index" do
    visit admin_aim_statistics_url
    assert_selector "h1", text: "Aim Statistics"
  end

  test "creating a Aim statistic" do
    visit admin_aim_statistics_url
    click_on "New Aim Statistic"

    fill_in "Aim users count", with: @admin_aim_statistic.aim_users_count
    fill_in "Ip", with: @admin_aim_statistic.ip
    fill_in "Serial number", with: @admin_aim_statistic.serial_number
    fill_in "State", with: @admin_aim_statistic.state
    fill_in "User", with: @admin_aim_statistic.user
    click_on "Create Aim statistic"

    assert_text "Aim statistic was successfully created"
    click_on "Back"
  end

  test "updating a Aim statistic" do
    visit admin_aim_statistics_url
    click_on "Edit", match: :first

    fill_in "Aim users count", with: @admin_aim_statistic.aim_users_count
    fill_in "Ip", with: @admin_aim_statistic.ip
    fill_in "Serial number", with: @admin_aim_statistic.serial_number
    fill_in "State", with: @admin_aim_statistic.state
    fill_in "User", with: @admin_aim_statistic.user
    click_on "Update Aim statistic"

    assert_text "Aim statistic was successfully updated"
    click_on "Back"
  end

  test "destroying a Aim statistic" do
    visit admin_aim_statistics_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Aim statistic was successfully destroyed"
  end
end
