class Admin::RecipesController < ApplicationController
  def index
    #新着順(投稿日降順)に並ぶよう指定
    @recipes = Recipe.all.order(created_at: :desc)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @user = User.find(@recipe.user_id)
  end

  def destroy
    recipe = Recipe.find(params[:id])  # データ（レコード）を1件取得
    recipe.destroy  # データ（レコード）を削除
    redirect_to '/admin/users/:id'  # 会員詳細画面へリダイレクト
  end
  
end
