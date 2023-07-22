class Public::RecipesController < ApplicationController
  def new
    # Viewへ渡すためのインスタンス変数に空のModelオブジェクトを生成する
    @recipe = Recipe.new
    # 新規投稿の際に、材料・分量と作り方のフォームがデフォルトで一つずつ設定されている状態にするため、1.timesと記載
    1.times { @recipe.ingredients.build }
    1.times { @recipe.steps.build }
  end

  def create
    # １.&2. データを受け取り新規登録するためのインスタンス作成
    recipe = Recipe.new(recipe_params)
    recipe.user_id = current_user.id
    # 3. データをデータベースに保存するためのsaveメソッド実行
    if recipe.save
      
      flash[:notice] = "投稿を作成しました"
      # 4. レシピ一覧画面へリダイレクト
      redirect_to public_recipes_path
    else
      render :new
    end
  end

  def index
  @q = Recipe.ransack(params[:q])
  @recipes = if params[:q].present?
               @q.result.where(is_deleted: false)
             else
               Recipe.published
                    .send(params[:most_favorited] ? :most_favorited : :latest)
             end.page(params[:page]).per(10)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @comment = Comment.new
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    recipe = Recipe.find(params[:id])
    recipe.update(recipe_params)
    flash[:notice] = "投稿を更新しました"
    #後々、マイページへ遷移するように修正する
    redirect_to public_recipe_path
  end

  def destroy
    recipe = Recipe.find(params[:id])  # データ（レコード）を1件取得
    user = User.find(params[:user_id])
    recipe.destroy  # データ（レコード）を削除
    flash[:notice] = "投稿を削除しました"
    redirect_to recipes_public_user_path(user)  # マイレシピへリダイレクト：削除した際に、該当のrecipe_idは消えてしまうのでuser_idが必要になる
  end

  private
  # GemのCocoonで使用するために、ingredients_attributes以下のコードを記載
  def recipe_params
    params.require(:recipe).permit(:title, :body, :post_image, :genre_id, :price_range_id, :steps, :description, ingredients_attributes: [:id, :name, :quantity, :_destroy], steps_attributes: [:id, :description, :step_image, :_destroy])
  end
end
