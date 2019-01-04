class CommentsController < ApplicationController
  before_action :require_user

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      flash[:success] = "Comment has been created succesfully!"
      redirect_to recipe_path(@recipe)
    else
      flash[:danger] = "Comment was not created!"
      redirect_back fallback_location: recipe_path(@recipe)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:description)
  end
end
