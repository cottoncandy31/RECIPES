class Public::UsersController < ApplicationController

  def show
    #他のユーザーからのアクセスを制限する
    is_matching_login_user
    @user = User.find(params[:id])
    @recipes = @user.recipes
    @users = User.all
  end

  def index
  end

  def edit
    #他のユーザーからのアクセスを制限する
    is_matching_login_user
    @user = User.find(params[:id])
  end

  def update
    #他のユーザーからのアクセスを制限する
    is_matching_login_user
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
    #他のユーザーからのアクセスを制限する
    is_matching_login_user
  end

  def recipes
    @user = User.find(params[:id])
    #下記、フォロー/フォロワー一覧表示のためのインスタンス変数
    @users = @user.followings + @user.followers
    #下記、@userの投稿ページにその人のレシピ投稿のみ表示させるためのインスタンス変数
    @recipes = Recipe.where(user_id: @user.id)
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
  end

  #退会フラグはupdateに値するが、マイページ更新の際のupdateアクションと被らないように、destroyアクションに退会処理を記載している
  def destroy
    #他のユーザーからのアクセスを制限する
    is_matching_login_user
    @user = User.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
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
    unless user.id == current_user.id
      redirect_to public_user_path(current_user)
    end
  end
end
