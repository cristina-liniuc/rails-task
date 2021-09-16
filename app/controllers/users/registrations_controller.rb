# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  APP_ID = 'Sdl8BesDB4qCTnKf2jiez2BFb_D5w8XFZ1mAEeffmNs'
  SECRET = '-L-Co75UGHSVixmeHxKB700bKqPCt1zIw3Ofr0qaSPM'
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    begin
      response = RestClient::Request.execute(method: :post,
                                             url: 'https://www.saltedge.com/api/v5/customers',
                                             payload: { 'data' => { 'identifier' => current_user.email } }.to_json,
                                             headers: { 'Accept' => 'application/json',
                                                        'Content-Type' => 'application/json',
                                                        'App-id' => APP_ID,
                                                        'Secret' => SECRET })
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    current_user.customer_id = ActiveSupport::JSON.decode(response.body)['data']['id'].to_i
    current_user.save
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

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
