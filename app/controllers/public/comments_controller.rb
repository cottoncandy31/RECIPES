class Public::CommentsController < ApplicationController
  def create
    @recipe = Recipe.find(params[:post_image_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_image_id = post_image.id
    comment.save
    redirect_to public_recipes_path
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
