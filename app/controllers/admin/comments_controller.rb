class Admin::CommentsController < ApplicationController
  #削除フラグの処理
  def update
    @comment = Comment.find(params[:id])
    @comment.update(is_deleted: true)
    flash[:notice] = "コメントを削除しました"
    redirect_to admin_recipes_path
  end
  
  private
    def recipe_params
      params.require(:comment).permit(:title, :body, :post_image)
    end
    
end
