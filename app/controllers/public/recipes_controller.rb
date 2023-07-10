class Public::RecipesController < ApplicationController
  def new
    # Viewへ渡すためのインスタンス変数に空のModelオブジェクトを生成する。
    @recipe = Recipe.new
  end

  def create
    # １.&2. データを受け取り新規登録するためのインスタンス作成
    recipe = Recipe.new(recipe_params)
    genre = Genre.find(recipe_params[:genre_id]) # recipe_paramsの中から選択したgenre_idを見つける
    recipe.genre_id = genre.id 
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
    @recipes = Recipe.all
    @post_comment = Comment.new
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

  def search
  end

  private
  # ストロングパラメータ
  def recipe_params
    params.require(:recipe).permit(:title, :body, :post_image, :genre_id)
  end
end
