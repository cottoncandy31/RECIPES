class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    #@users = User.all
    @users = User.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes
    @users = User.all
  end

  #退会フラグの処理
  def update
    @user = User.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to admin_users_path
  end
  
end
