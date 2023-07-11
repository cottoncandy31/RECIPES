class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes
    @users = User.all
  end
  
  #退会フラグはupdateに値するが、マイページ更新の際のupdateアクションと被らないように、destroyアクションに退会処理を記載している
  def update
    @user = User.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to admin_users_path
  end
end
