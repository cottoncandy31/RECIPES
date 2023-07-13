class Public::BookmarkedRecipesController < ApplicationController
  before_action :authenticate_user!
  
  def index
   @recipes = User.find(params[:user_id]).bookmarked_recipes
  end

  def show
  end
end
