class Public::CommentsController < ApplicationController
  def create
    recipe = Recipe.find(params[:recipe_id])
    comment = current_user.comments.new(comment_params)
    comment.recipe_id = recipe.id
    if comment.save
       redirect_to public_recipe_path(params[:recipe_id])
      # 以下の処理やリダイレクト先などを追加する
    else
      # エラーハンドリングの処理を追加する
       
    end
  end

  def edit
  end

  def update
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to public_recipe_path(params[:recipe_id])
  end
  
  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
