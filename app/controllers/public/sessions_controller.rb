# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  
  #ゲストログイン機能:/cooking_recipes/config/routes.rbよりゲストログインのためのルーティングを設定している
  def guest_sign_in
    user = User.guest
    sign_in user
    flash[:notice] = "guestuserでログインしました"
    redirect_to public_user_path(user)
  end

  def after_sign_in_path_for(resource_or_scope)
    flash[:notice] = "ログインしました"
    public_user_path(current_user)
  end
  def after_sign_out_path_for(resource_or_scope)
    flash[:notice] = "ログアウトしました"
    root_path
  end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  
  protected
  #退会処理を行った会員が、同じアカウントでログイン出来ないようにする
  # 退会しているかを判断するメソッド
  def user_state
    @user = user.find_by(email: params[:user][:email])
    # return false if @user.nil?
    if @user && @user.valid_password?(params[:user][:password]) && @user.deleted?
    flash[:warning] = "退会済みです。再度ご登録をしてご利用ください"
    redirect_to new_user_registration_path
    end
  end
  
  private
  
  
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
