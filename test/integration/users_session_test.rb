require 'test_helper'

class UsersSessionTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "John", 
                          email: "john@example.com",
                          password: "password", 
                          password_confirmation: "password"
             )
  end

  test "invalid login is rejected" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: " ", password: " " } }
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "valid login credentials accepted and begin session" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: @user.email, password: @user.password } }
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
  end
end
