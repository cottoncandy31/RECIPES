class Public::RecipesController < ApplicationController
  def new
    # Viewへ渡すためのインスタンス変数に空のModelオブジェクトを生成する。
    @recipe = Recipe.new  
  end

  def create
    # １.&2. データを受け取り新規登録するためのインスタンス作成
    recipe = Recipe.new(recipe_params)
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
  end

  def show
  end

  def edit
  end

  def update
  end

  def search
  end
  
  private
  # ストロングパラメータ
  def recipe_params
    params.require(:recipe).permit(:title, :body, :post_image)
  end
end
