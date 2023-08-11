class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:search_email].present?
      @users = User.where("email LIKE ?", "%#{params[:search_email]}%").page(params[:page]).per(10)
    else
      @users = User.page(params[:page]).per(10)
    end
  end
  
  # user_status管理
  def edit
    @user = User.find(params[:id])
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
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to admin_users_path
  end
  
  private

  def user_params
    params.require(:user).permit(:user_status)
  end
end
