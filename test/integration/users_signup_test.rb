require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "should get a signup url" do
    get signup_path
    assert_response :success
  end

  test "reject an invalid signup" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: " ", email: " ", password: " ", password_confirmation: " " } }
    end
    assert_template "users/new"
    assert_select "h4.alert-heading"
  end

  test "accept valid signup" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { 
        name: "John", 
        email: "john@example.com", 
        password: "password", 
        password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
  end
end
