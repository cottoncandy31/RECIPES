class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:show, :edit, :update, :check, :destroy]
  
  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes
    @users = User.all
  end

  def index
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "登録情報を更新しました"
      redirect_to public_user_path(@user.id)
    else
      render :edit
    end
  end
  
  #ユーザーの退会確認
  def check
  end

  def recipes
    @user = User.find(params[:id])
    #下記、フォロー/フォロワー一覧表示のためのインスタンス変数
    @users = @user.followings.published + @user.followers.published
    #下記、@userの投稿ページにその人のレシピ投稿のみ表示させるためのインスタンス変数
    @recipes = Recipe.where(user_id: @user.id)
    @report = Report.new
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings.published
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.published
  end

  #退会フラグはupdateに値するが、マイページ更新の際のupdateアクションと被らないように、destroyアクションに退会処理を記載している
  def destroy
    @user = User.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
    @user.favorites.destroy_all
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end
  
  #他のユーザーからのアクセスを制限する
  def is_matching_login_user
  user = User.find(params[:id])
  unless user.id == current_user&.id
    if current_user
      redirect_to public_user_path(current_user)
    else
      redirect_to new_user_session_path
    end
  end
  end
  
end
