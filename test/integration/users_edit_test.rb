require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: "John", 
                          email: "john@example.com",
                          password: "password", 
                          password_confirmation: "password"
                        )
    @user2 = User.create!(name: "John2", 
                          email: "john2@example.com",
                          password: "password", 
                          password_confirmation: "password"
                        )
    @user3_admin = User.create!(name: "John3", 
                          email: "john3@example.com",
                          password: "password", 
                          password_confirmation: "password",
                          admin: true
                        )
  end

  test "reject an invalid edit" do
    sign_up_as(@user, "password")
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: " ", email: "test@test.com"} }
    assert_template "users/edit"
    assert_select "h4.alert-heading"
  end

  test "accept valid edit" do
    sign_up_as(@user, "password")
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { 
      name: "NewName", 
      email: "newmail@test.com"
    } }
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_match "NewName", @user.name
    assert_match "newmail@test.com", @user.email
  end

  test "accept edit attempt by admin user" do
    sign_up_as(@user3_admin, "password")
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { 
      name: "NewName", 
      email: "newmail@test.com"
    } }
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_match "NewName", @user.name
    assert_match "newmail@test.com", @user.email
  end

  test "redirect edit attempt by another non-admin user" do
    sign_up_as(@user2, "password")
    patch user_path(@user), params: { user: { 
      name: "NewName", 
      email: "newmail@test.com"
    } }
    assert_redirected_to users_path
    assert_not flash.empty?
    @user.reload
    assert_match "John", @user.name
    assert_match "john@example.com", @user.email
  end
end
