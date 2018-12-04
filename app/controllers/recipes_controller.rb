class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = User.first #this will be removed

    if @recipe.save
      flash[:success] = "Recipe was created successuflly!"
      redirect_to recipe_path(@recipe)
    else
      render "new"
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description)
  end
end
