class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:show, :edit, :update]

  def index
    @ingredients = Ingredient.page(params[:page]).per(5)
  end

  def new
  end

  def create
  end

  def show   
    @ingredient_recipes = @ingredient.recipes.page(params[:page]).per(5)
  end

  def edit
  end

  def update
  end

  private
    def set_ingredient
      @ingredient = Ingredient.find(params[:id])
    end
end
