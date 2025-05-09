# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in

    # DELETE /resource/sign_out

    protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
    #
    def after_sign_in_path_for(_resource)
      flash[:notice] = 'サインインに成功しました。'
      tweets_path
    end

    def after_sign_out_path_for(_resource)
      flash[:notice] = 'サインアウトに成功しました。'
      new_user_session_path
    end
  end
end
