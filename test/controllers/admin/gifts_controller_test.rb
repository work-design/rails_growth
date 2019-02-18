require 'test_helper'

class Admin::GiftsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_gift = admin_gifts(:one)
  end

  test "should get index" do
    get admin_gifts_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_gift_url
    assert_response :success
  end

  test "should create admin_gift" do
    assert_difference('Gift.count') do
      post admin_gifts_url, params: { admin_gift: { amount: @admin_gift.amount, code: @admin_gift.code, name: @admin_gift.name, praise_incomes_count: @admin_gift.praise_incomes_count } }
    end

    assert_redirected_to admin_gift_url(Gift.last)
  end

  test "should show admin_gift" do
    get admin_gift_url(@admin_gift)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_gift_url(@admin_gift)
    assert_response :success
  end

  test "should update admin_gift" do
    patch admin_gift_url(@admin_gift), params: { admin_gift: { amount: @admin_gift.amount, code: @admin_gift.code, name: @admin_gift.name, praise_incomes_count: @admin_gift.praise_incomes_count } }
    assert_redirected_to admin_gift_url(@admin_gift)
  end

  test "should destroy admin_gift" do
    assert_difference('Gift.count', -1) do
      delete admin_gift_url(@admin_gift)
    end

    assert_redirected_to admin_gifts_url
  end
end
