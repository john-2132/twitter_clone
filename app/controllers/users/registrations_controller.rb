# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    # before_action :add_uid_to_user, only: [:create]
    # before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    def new
      build_resource
      @profile = @user.build_profile
      respond_with resource
    end

    # POST /resource
    def create # rubocop:disable Metric/AbcSize,Metrics/MethodLength
      build_resource(sign_up_params)
      resource.uid = SecureRandom.uuid

      resource.save
      yield resource if block_given?
      if resource.persisted?
        profile = Profile.find(resource.id)
        profile.update(
          name: sign_up_params[:profile_attributes][:name],
          birth_date:,
          phone_number: sign_up_params[:profile_attributes][:phone_number]
        )
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up,
                                        keys: [:email, :password, :password_confirmation,
                                               { profile_attributes: %i[name birth_date phone_number] }])
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    def after_inactive_sign_up_path_for(_resource)
      flash[:notice] = 'サインアップに成功しました。'
      new_user_session_path
    end

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   { profile_attributes: %i[name birth_date phone_number] })
    end

    def birth_date
      profile_params = sign_up_params[:profile_attributes]
      Date.new(
        profile_params[:"birth_date(1i)"].to_i,
        profile_params[:"birth_date(2i)"].to_i,
        profile_params[:"birth_date(3i)"].to_i
      )
    end

    # def add_uid_to_user
    #   build_resource(sign_up_params)
    #   resource.uid = generate_uid
    # end

    def generate_uid
      SecureRandom.uuid
    end
  end
end
