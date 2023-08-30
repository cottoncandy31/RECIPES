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
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    #「作り方」に添付する画像の画像認識処理
    step_tags = []
    recipe_params[:steps_attributes].each.with_index do |step_param, i|
      if step_param[1][:step_image].present?
        tags = Vision.get_image_data(step_param[1][:step_image])
        if tags.include?("Food") || tags.include?("Ingredien") || tags.include?("Recipe") || tags.include?("Tableware") || tags.include?("Dishware") || tags.include?("Drinkware")
          tags.each do |tag|
            step_tags.push({:index=> i, :name=> tag})
          end
        else
          flash[:alert] = "不適切な画像を検知しました。料理に関連する画像を選択してください。"
          render :new
          return
        end
      end
    end
    # レシピ画像の画像認識処理
    if recipe_params[:post_image].present?
      tags = Vision.get_image_data(recipe_params[:post_image]) #Google Vision API (画像認識)
      if tags.include?("Food") || tags.include?("Ingredien") || tags.include?("Recipe") || tags.include?("Tableware") || tags.include?("Dishware") || tags.include?("Drinkware")
        # データをデータベースに保存するためのsaveメソッド実行
        if @recipe.save
          tags.each do |tag|
            @recipe.tags.create(name: tag)
          end
          step_tags.each do |tag |
            step = @recipe.steps.order(id: :asc)[tag[:index]]
            Tag.create!(name: tag[:name], step_id: step.id)
          end
          flash[:notice] = "投稿を作成しました"
          # 4. レシピ一覧画面へリダイレクト
          redirect_to public_recipes_path
        else
          render :new
        end
      else
        flash[:alert] = "不適切な画像を検知しました。料理に関連する画像を選択してください。"
        render :new
      end
    #画像の添付がない場合の処理
    else
      if @recipe.save
        flash[:notice] = "投稿を作成しました"
        # 4. レシピ一覧画面へリダイレクト
        redirect_to public_recipes_path
      else
        render :new
      end
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
      @recipes = @q.result.joins(:user).where(is_deleted: false, users: { is_deleted: false }).page(params[:page]).per(10)
    else
      #ransack検索機能をかけていない場合
      @q = Recipe.ransack(nil)
      #退会済みユーザーのデータは非公開にしている
      @recipes = Recipe.published
      # デフォルトではis_deleted: trueも含めて表示する
      @recipes = @recipes.or(Recipe.where(is_deleted: true))
      if params[:most_favorited]
        # 人気順に並ぶよう指定
        @recipes = Kaminari.paginate_array(@recipes.most_favorited).page(params[:page]).per(10)
      else
        # 新着順(投稿日降順)に並ぶよう指定
        @recipes = @recipes.latest.page(params[:page]).per(10)
      end
    end
  end

  def show
    #退会済みユーザーのレシピ詳細、もしくは管理者が削除したレシピ詳細画面へ直接リンクからアクセスした際に「レシピがありません」と表示するよう設定している。
    #find_by(id: params[:id])を記述することで、削除済みレシピに対して@recipeにnilが代入されエラー画面が表示されないように設定
    @recipe = Recipe.find_by(id: params[:id])
    #退会済みユーザーかどうか、/RECIPES/app/views/public/recipes/show.html.erbの冒頭で確かめるために@userを定義している
    @user = @recipe.user
    @recipeTags = []
    @recipe.tags.each do |tag|
      @recipeTags.push(tag.name)
    end
    @comment = Comment.new
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    #「作り方」に添付する画像の画像認識処理
    recipe_params[:steps_attributes].each do |step_param|
      if step_param[1][:step_image].present?
        step_tags = Vision.get_image_data(step_param[1][:step_image])
        unless step_tags.include?("Food") || step_tags.include?("Ingredien") || step_tags.include?("Recipe") || step_tags.include?("Tableware") || step_tags.include?("Dishware") || step_tags.include?("Drinkware")
          flash[:alert] = "不適切な画像を検知しました。料理に関連する画像を選択してください。"
          render :edit
          return
        end
      end
    end
    if recipe_params[:post_image].present?
      # レシピ画像の画像認識処理
      tags = Vision.get_image_data(recipe_params[:post_image]) # Google Vision API (画像認識)
      unless tags.include?("Food") || tags.include?("Ingredien") || tags.include?("Recipe") || tags.include?("Tableware") || tags.include?("Dishware") || tags.include?("Drinkware")
        flash[:alert] = "不適切な画像を検知しました。料理に関連する画像を選択してください。"
        render :edit
        return
      end
      # レシピ画像が添付されている場合のアップデート処理
      if @recipe.update(recipe_params)
        @recipe.tags.destroy_all
        tags = Vision.get_image_data(@recipe.post_image)
        tags.each do |tag|
          @recipe.tags.create(name: tag)
        end
        if recipe_params[:steps_attributes][recipe_params[:steps_attributes].keys.first][:step_image].present?
          @recipe.steps.each do | step |
            step.tags.destroy_all
            tags = Vision.get_image_data(step.step_image)
            tags.each do |tag|
              step.tags.create(name: tag)
            end
          end
        end
        flash[:notice] = "投稿を更新しました"
        # レシピ詳細画面へ遷移する
        redirect_to public_recipe_path
      else
        flash[:alert] = "投稿の更新に失敗しました"
        render :edit
      end
    else
      #画像の添付がない場合のアップデート処理
      if @recipe.update(recipe_params)
        flash[:notice] = "投稿を更新しました"
        # レシピ詳細画面へ遷移する
        redirect_to public_recipe_path
      else
      flash[:alert] = "投稿の更新に失敗しました"
      render :edit
      end
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
    params.require(:recipe).permit(:title, :body, :serving, :cooking_time, :post_image, :genre_id, :price_range_id, :steps, :description, ingredients_attributes: [:id, :name, :quantity, :price, :_destroy], steps_attributes: [:id, :description, :step_image, :_destroy])
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
