class Public::CommentsController < ApplicationController
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = current_user.comments.new(comment_params)
    @comment.recipe_id = @recipe.id
    if @comment.save
      redirect_to public_recipe_path(params[:recipe_id])
    else
      # エラーの処理について
      flash[:alert] = "コメントの保存に失敗しました"
      render "public/recipes/show"
    end
  end

  def edit
  end

  def update
  end

  def destroy
    Comment.find(params[:id]).destroy
    flash[:notice] = "コメントを削除しました。"
    redirect_to public_recipe_path(params[:recipe_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
