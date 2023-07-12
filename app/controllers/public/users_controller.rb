class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes
    @users = User.all
  end

  def edit
  end

  def update
  end

  def check
  end
  
  def recipes
    @user = User.find(params[:id])
    #下記、フォロー/フォロワー一覧表示のためのインスタンス変数
    @users = @user.followings + @user.followers
    #下記、@userの投稿ページにその人のレシピ投稿のみ表示させるためのインスタンス変数
    @recipes = Recipe.where(user_id: @user.id)
  end
  
  #退会フラグはupdateに値するが、マイページ更新の際のupdateアクションと被らないように、destroyアクションに退会処理を記載している
  def destroy
    @user = User.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end
end
