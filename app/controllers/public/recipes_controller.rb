class Public::RecipesController < ApplicationController
  def new
    # Viewへ渡すためのインスタンス変数に空のModelオブジェクトを生成する。
    @recipe = Recipe.new
  end

  def create
    # １.&2. データを受け取り新規登録するためのインスタンス作成
    recipe = Recipe.new(recipe_params)
    # genre = Genre.find(recipe_params[:genre_id]) # recipe_paramsの中から選択したgenre_idを見つける
    # price_range = PriceRange.find(recipe_params[:price_range_id]) # pricerange_paramの中から選択したpricerange_idを見つける
    # recipe.genre_id = genre.id
    # recipe.price_range_id = price_range.id
    recipe.user_id = current_user.id
    # 3. データをデータベースに保存するためのsaveメソッド実行
    if recipe.save
    # 4. レシピ一覧画面へリダイレクト
      redirect_to public_recipes_path
    else
      render :new
    end
  end

  def index
    @post_comment = Comment.new
    if params[:latest]
      @recipes = Recipe.published.latest
    elsif params[:old]
      @recipes = Recipe.published.old
    elsif params[:most_favorited]
      @recipes = Recipe.published.most_favorited
    else
      #新着順(投稿日降順)に並ぶよう指定
      @recipes = Recipe.published.order(created_at: :desc)
    end
    
    #ransack検索機能のための記述
    @q = Recipe.ransack(params[:q])
    @recipes = @q.result.order(created_at: :desc)
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
    #後々、マイページへ遷移するように修正する
    redirect_to public_recipe_path
  end

  def destroy
    recipe = Recipe.find(params[:id])  # データ（レコード）を1件取得
    recipe.destroy  # データ（レコード）を削除
    redirect_to '/public/users/:id'  # マイページへリダイレクト
  end

  private
  # ストロングパラメータ
  def recipe_params
    params.require(:recipe).permit(:title, :body, :post_image, :genre_id, :price_range_id)
  end
end
