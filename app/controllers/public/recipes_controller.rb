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
      flash[:notice] = "投稿を作成しました"
      # 4. レシピ一覧画面へリダイレクト
      redirect_to public_recipes_path
    else
      render :new
    end
  end

  def index
    if params[:q].present?
      #ransackのキーワード検索の中から、さらに新着順や退会済みユーザーのデータを除いた検索に絞り込んで検索したい場合
      search_params = params[:q].merge(published: true)
      if params[:most_favorited]
        search_params = params[:q].merge(most_favorited: true)
      else
        search_params = params[:q].merge(latest: true)
      end
      #ransack検索機能のための記述
      @q = Recipe.ransack(search_params)
      #検索後、管理者によって既に削除された投稿は表示させないようにしている
      @recipes = @q.result.where(is_deleted: false)
    else
      #ransack検索機能をかけていない場合
      @q = Recipe.ransack(nil)
      #退会済みユーザーのデータは非公開にしている
      @recipes = Recipe.published
        #人気順
      if params[:most_favorited]
        @recipes = @recipes.most_favorited
      else
        #新着順(投稿日降順)に並ぶよう指定
        @recipes = @recipes.latest
      end
    end
    @recipes = @recipes.page(params[:page]).per(10)
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
  # ストロングパラメータ
  def recipe_params
    params.require(:recipe).permit(:title, :body, :post_image, :genre_id, :price_range_id)
  end
end
