class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy, :like]
  before_action :require_user, except: [:index, :show, :like]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def index
    @recipes = Recipe.page(params[:page]).per(5)
  end

  def show
    @comment = Comment.new
    @comments = @recipe.comments.page(params[:page]).per(3)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    if @recipe.save
      flash[:success] = "Recipe was created successfully!"
      redirect_to recipe_path(@recipe)
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Recipe was updated successfully!"
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end

  def destroy
    Recipe.find(params[:id]).destroy
    flash[:success] = "Recipe was successfully deleted"
    redirect_to recipes_path
  end

  def like
    like = Like.create(like: params[:like], user: current_user, recipe: @recipe)
    
    if like.valid?
      flash[:success] = "Your selection was succesful"
      redirect_back(fallback_location: recipe_path(@recipe))
    else
      flash[:danger] = "You can only like/dislike a recipe once"
      redirect_back(fallback_location: recipe_path(@recipe))
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :description, ingredient_ids: [])
  end

  def require_same_user
    if current_user != @recipe.user && !current_user.admin?
      flash[:danger] = "You can only edit or delete your own recipes"
      redirect_to recipes_path
    end
  end
end
