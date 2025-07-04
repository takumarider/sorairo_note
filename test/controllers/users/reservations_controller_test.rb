require "test_helper"

class Users::ReservationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get users_reservations_new_url
    assert_response :success
  end

  test "should get create" do
    get users_reservations_create_url
    assert_response :success
  end

  test "should get edit" do
    get users_reservations_edit_url
    assert_response :success
  end

  test "should get update" do
    get users_reservations_update_url
    assert_response :success
  end
end
