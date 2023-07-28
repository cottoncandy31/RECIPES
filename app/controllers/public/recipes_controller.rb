class Public::RecipesController < ApplicationController
  before_action :is_matching_login_user, only: [:edit]

  def new
    # Viewへ渡すためのインスタンス変数に空のModelオブジェクトを生成する
    @recipe = Recipe.new
    # 新規投稿の際に、材料・分量と作り方のフォームがデフォルトで一つずつ設定されている状態にするため、1.timesと記載
    1.times { @recipe.ingredients.build }
    1.times { @recipe.steps.build }
  end

  def create
    # １.&2. データを受け取り新規登録するためのインスタンス作成
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    # 3. データをデータベースに保存するためのsaveメソッド実行
    if @recipe.save
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
      #検索後、管理者によって既に削除された投稿と退会済みユーザーの投稿は表示させないようにしている
      @recipes = @q.result.joins(:user).where(is_deleted: false, users: { is_deleted: false })
    else
      #ransack検索機能をかけていない場合
      @q = Recipe.ransack(nil)
      #退会済みユーザーのデータは非公開にしている
      @recipes = Recipe.published
      # デフォルトではis_deleted: trueも含めて表示する
      @recipes = @recipes.or(Recipe.where(is_deleted: true))
      if params[:most_favorited]
        # 人気順に並ぶよう指定
        @recipes = @recipes.most_favorited
      else
        # 新着順(投稿日降順)に並ぶよう指定
        @recipes = @recipes.latest
      end
    end
    if params[:most_favorited]
      @recipes = Kaminari.paginate_array(@recipes).page(params[:page]).per(10)
    else
      @recipes = @recipes.page(params[:page]).per(10)
    end
  end

  def show
    #退会済みユーザーのレシピ詳細、もしくは管理者が削除したレシピ詳細画面へ直接リンクからアクセスした際に「レシピがありません」と表示するよう設定している。
    #find_by(id: params[:id])を記述することで、削除済みレシピに対して@recipeにnilが代入されエラー画面が表示されないように設定
    @recipe = Recipe.find_by(id: params[:id])
    #退会済みユーザーかどうか、/RECIPES/app/views/public/recipes/show.html.erbの冒頭で確かめるために@userを定義している
    @user = @recipe.user
    @comment_user_delete_count = 0
    @recipe.comments.each do |comment|
      if comment.user.is_deleted == true
        @comment_user_delete_count += 1
      end
    end
    @comment = Comment.new
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      flash[:notice] = "投稿を更新しました"
      #レシピ詳細画面へ遷移する
      redirect_to public_recipe_path
    else
      flash[:alert] = "投稿の更新に失敗しました"
      render :edit
    end
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

  #他のユーザーからのアクセスを制限する(editアクションで使用)
  def is_matching_login_user
  user = Recipe.find(params[:id]).user
  unless user.id == current_user&.id
    if current_user
      redirect_to public_user_path(current_user)
    else
      redirect_to new_user_session_path
    end
  end
  end
end
