class Public::BookmarkedRecipesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    #他のユーザーからのアクセスを制限する
    is_matching_login_user
    @recipes = User.find(params[:user_id]).bookmarked_recipes
  end

  def show
  end
  
  private
  
  #他のユーザーからのアクセスを制限する
  def is_matching_login_user
    user = User.find(params[:user_id])
    unless user.id == current_user.id
      redirect_to public_user_path(current_user)
    end
  end
end
