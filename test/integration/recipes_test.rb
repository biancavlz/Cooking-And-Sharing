require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
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
    sign_up_as(@user, "password")
    get recipe_path(@recipe1)
    assert_template 'recipes/show'
    assert_match @recipe1.name, response.body
    assert_match @recipe1.description, response.body
    assert_match @user.name, response.body
    assert_select "a[href=?]", edit_recipe_path(@recipe1), text: "Edit"
    assert_select "a[href=?]", recipe_path(@recipe1), text: "Delete"
    assert_select "a[href=?]", recipes_path, text: "Back to recipes"
  end

  test "creates new valid recipe" do
    sign_up_as(@user, "password")
    get new_recipe_path
    assert_template "recipes/new"
    name_of_recipe = "Burritos"
    description_of_recipe = "Tortilla, beef, onion cook for 5 minutes"
    assert_difference "Recipe.count", 1 do
      post recipes_path, params: { recipe: { name: name_of_recipe, description: description_of_recipe } }
    end

    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end

  test "reject invalid recipe submission" do
    sign_up_as(@user, "password")
    get new_recipe_path
    assert_template "recipes/new"
    assert_no_difference "Recipe.count" do
      post recipes_path, params: { recipe: { name: " ", description: " " } }
    end

    assert_template "recipes/new"
    assert_select "h4.alert-heading"
  end

  test "reject invalid recipe update" do
    sign_up_as(@user, "password")
    get edit_recipe_path(@recipe1)
    assert_template "recipes/edit"
    patch recipe_path(@recipe1), params: { recipe: { name: " ", description: "new description" } }
    assert_template "recipes/edit"
    assert_select "h4.alert-heading"
  end

  test "successfully added a recipe" do
    sign_up_as(@user, "password")
    get edit_recipe_path(@recipe1)
    assert_template "recipes/edit"
    updated_name = "Updated name"
    updated_description = "updated description"
    patch recipe_path(@recipe1), params: { recipe: { name: updated_name, description: updated_description } }
    assert_redirected_to @recipe1
    assert_not flash.empty?
    @recipe1.reload
    assert_match updated_name, @recipe1.name
    assert_match updated_description, @recipe1.description
  end

  test "successfully delete a recipe" do
    sign_up_as(@user, "password")
    get recipe_path(@recipe1)
    assert_template 'recipes/show'
    assert_select "a[href=?]", recipe_path(@recipe1), text: "Delete"
    assert_difference "Recipe.count", -1 do
      delete recipe_path(@recipe1)
    end
    assert_redirected_to recipes_path
    assert_not flash.empty?
  end
end
