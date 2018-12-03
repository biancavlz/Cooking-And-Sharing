require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: "John", email: "john@example.com")
    @recipe1 = Recipe.create!(name: "tacos", description: "ricos tacos", user: @user)
    @recipe2 = @user.recipes.build(name: "Pozole", description: "Rico pozole")
    @recipe2.save
  end

  test "should get recipes INDEX" do
    get recipes_path

    assert_response :success
  end

  test "should get recipes listing" do
    get recipes_path

    assert_template "recipes/index"
    assert_select "a[href=?]", recipe_path(@recipe1), text: @recipe1.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end

  test "should have recipe SHOW" do
    get recipe_path(@recipe1)
    assert_template 'recipes/show'
    assert_match @recipe1.name, response.body
    assert_match @recipe1.description, response.body
    assert_match @user.name, response.body
  end
end
