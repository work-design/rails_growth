require 'test_helper'
class Growth::Admin::AimCodesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @aim_code = aim_codes(:one)
  end

  test 'index ok' do
    get url_for(controller: 'growth/admin/aim_codes')

    assert_response :success
  end

  test 'new ok' do
    get url_for(controller: 'growth/admin/aim_codes')

    assert_response :success
  end

  test 'create ok' do
    assert_difference('AimCode.count') do
      post(
        url_for(controller: 'growth/admin/aim_codes', action: 'create'),
        params: { aim_code: { action_name: @growth_admin_aim_code.action_name, code: @growth_admin_aim_code.code, controller_path: @growth_admin_aim_code.controller_path } },
        as: :turbo_stream
      )
    end

    assert_response :success
  end

  test 'show ok' do
    get url_for(controller: 'growth/admin/aim_codes', action: 'show', id: @aim_code.id)

    assert_response :success
  end

  test 'edit ok' do
    get url_for(controller: 'growth/admin/aim_codes', action: 'edit', id: @aim_code.id)

    assert_response :success
  end

  test 'update ok' do
    patch(
      url_for(controller: 'growth/admin/aim_codes', action: 'update', id: @aim_code.id),
      params: { aim_code: { action_name: @growth_admin_aim_code.action_name, code: @growth_admin_aim_code.code, controller_path: @growth_admin_aim_code.controller_path } },
      as: :turbo_stream
    )

    assert_response :success
  end

  test 'destroy ok' do
    assert_difference('AimCode.count', -1) do
      delete url_for(controller: 'growth/admin/aim_codes', action: 'destroy', id: @aim_code.id), as: :turbo_stream
    end

    assert_response :success
  end

end
