require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = User.create!(name: "John", 
                          email: "john@example.com",
                          password: "password", 
                          password_confirmation: "password"
                          )
    @user2 = User.create!(name: "Smith", 
                          email: "smith@example.com",
                          password: "password", 
                          password_confirmation: "password"
                        )
  end

  test "should get users INDEX" do
    get users_path
    assert_response :success
  end

  test "should get users listing" do
    get users_path

    assert_template "users/index"
    assert_select "a[href=?]", user_path(@user1), text: @user1.name
    assert_select "a[href=?]", user_path(@user2), text: @user2.name
  end

  test "should  delete user" do
    get users_path
    assert_template "users/index"
    assert_difference "User.count", -1 do
      delete user_path(@user1)
    end

    assert_redirected_to users_path
    assert_not flash.empty?
  end
end
