require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: "John", 
                          email: "john@example.com",
                          password: "password", 
                          password_confirmation: "password"
                        )
    @recipe1 = Recipe.create!(name: "tacos", description: "ricos tacos", user: @user)
    @recipe2 = @user.recipes.build(name: "Pozole", description: "Rico pozole")
    @recipe2.save
  end

  test "should get user show" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select "a[href=?]", recipe_path(@recipe1), text: @recipe1.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
    assert_match @recipe1.description, response.body
    assert_match @recipe2.description, response.body
    assert_match @user.name, response.body
  end
end
