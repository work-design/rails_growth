require "application_system_test_case"

class AimCodesTest < ApplicationSystemTestCase
  setup do
    @growth_admin_aim_code = growth_admin_aim_codes(:one)
  end

  test "visiting the index" do
    visit growth_admin_aim_codes_url
    assert_selector "h1", text: "Aim codes"
  end

  test "should create aim code" do
    visit growth_admin_aim_codes_url
    click_on "New aim code"

    fill_in "Action name", with: @growth_admin_aim_code.action_name
    fill_in "Code", with: @growth_admin_aim_code.code
    fill_in "Controller path", with: @growth_admin_aim_code.controller_path
    click_on "Create Aim code"

    assert_text "Aim code was successfully created"
    click_on "Back"
  end

  test "should update Aim code" do
    visit growth_admin_aim_code_url(@growth_admin_aim_code)
    click_on "Edit this aim code", match: :first

    fill_in "Action name", with: @growth_admin_aim_code.action_name
    fill_in "Code", with: @growth_admin_aim_code.code
    fill_in "Controller path", with: @growth_admin_aim_code.controller_path
    click_on "Update Aim code"

    assert_text "Aim code was successfully updated"
    click_on "Back"
  end

  test "should destroy Aim code" do
    visit growth_admin_aim_code_url(@growth_admin_aim_code)
    click_on "Destroy this aim code", match: :first

    assert_text "Aim code was successfully destroyed"
  end
end
