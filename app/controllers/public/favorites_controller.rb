class Public::FavoritesController < ApplicationController
  def create
    @recipe = Recipe.find(params[:recipe_id])
    favorite = current_user.favorites.new(recipe_id: @recipe.id)
    favorite.save
    # いいねを保存したあと、redirect_toもrenderもないので
    # view/controller名/アクション名.js.erbが呼び出される。下記は非同期通信に設定する前の記述
    # redirect_to public_recipes_path
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    favorite = current_user.favorites.find_by(recipe_id: @recipe.id)
    favorite.destroy
    # いいねを保存したあと、redirect_toもrenderもないので
    # view/controller名/アクション名.js.erbが呼び出される。下記は非同期通信に設定する前の記述
  #   redirect_to public_recipes_path
  end
  
  def index
  end
end
