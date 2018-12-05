require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "John", 
                          email: "user@example.com", 
                          password: "password", 
                          password_confirmation: "password"
                        )
    @recipe = @user.recipes.build(name: "Tacos", description: "delicious tacos")
  end

  test "without user should be invalid" do
    @recipe.user_id = nil
    assert_not @recipe.valid?
  end

  test "should be valid" do
    assert @recipe.valid?
  end

  test "name should be present" do
    @recipe.name = " "
    assert_not @recipe.valid?
  end

  test "description should be present" do
    @recipe.description = " "
    assert_not @recipe.valid?
  end

  test "description should not be less than 5 characters" do
    @recipe.description = "Taco"
    assert_not @recipe.valid?
  end

  test "description should not be more than 500 characters" do
    @recipe.description = "a" * 501
    assert_not @recipe.valid?
  end
end
