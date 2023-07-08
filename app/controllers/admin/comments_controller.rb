class Admin::CommentsController < ApplicationController
  def destroy
  end
  
  private
    def recipe_params
      params.require(:comme).permit(:title, :body, :post_image, :star)
    end
    
end
