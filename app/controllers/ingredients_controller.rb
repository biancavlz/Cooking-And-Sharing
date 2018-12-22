class IngredientsController < ApplicationController
  
  def index
    @ingredients = Ingredient.page(params[:page]).per(5)
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end
end
