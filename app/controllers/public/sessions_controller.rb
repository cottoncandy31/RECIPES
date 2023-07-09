# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  def after_sign_up_path_for(resource_or_scope)
    public_recipes_path
  end
  def after_sign_in_path_for(resource_or_scope)
    public_recipes_path
  end
  def after_sign_out_path_for(resource_or_scope)
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
  # 退会しているかを判断するメソッド
  def user_state
    @user = user.find_by(email: params[:user][:email])
    # return false if @user.nil?
    
    if @user
      if @user.valid_password?(params[:user][:password]) && (@user.deleted? == true)
        flash[:warning] = "退会済みです。再度ご登録をしてご利用ください"
        redirect_to new_user_registration_path
      else
      end
    else
    end
  end
  
  private
  
  
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
