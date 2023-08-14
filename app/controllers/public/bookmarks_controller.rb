class Public::BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @recipe = Recipe.find(params[:recipe_id])
    bookmark = @recipe.bookmarks.new(user_id: current_user.id)
    bookmark.save
    #非同期通信化
    render 'public/bookmarked_recipes/create'
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    bookmark = @recipe.bookmarks.find_by(user_id: current_user.id)
    bookmark.destroy
    #非同期通信化
    render 'public/bookmarked_recipes/destroy'
  end
end
