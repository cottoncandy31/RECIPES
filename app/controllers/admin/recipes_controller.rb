class Admin::RecipesController < ApplicationController
  before_action :authenticate_admin!
  
  def index
  # 新着順(投稿日降順)に並ぶよう指定し、ページネーションを設定
  @recipes = Recipe.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @user = User.find(@recipe.user_id)
  end
  
  def update
    # 削除フラグの処理
    @recipe = Recipe.find(params[:id])
    @recipe.update(is_deleted: true)
    flash[:notice] = "投稿を削除しました"
    redirect_to admin_recipes_path #レシピ一覧画面へリダイレクト
  end
  
end
