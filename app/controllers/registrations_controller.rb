# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  layout 'application' # Optional: ensure layout is HTML-compatible

  # GET /signup
  def new
    super
  end

  # POST /signup
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?

    if resource.persisted?
      if resource.active_for_authentication?
        flash[:notice] = I18n.t('devise.registrations.signed_up') if is_flashing_format?
        sign_up(resource_name, resource) # remove if you want to delay login until confirmation
        redirect_to after_sign_up_path_for(resource)
      else
        flash[:notice] = I18n.t('devise.registrations.signed_up_but_unconfirmed') if is_flashing_format?
        expire_data_after_sign_in!
        redirect_to after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def after_sign_up_path_for(resource)
    root_path # or '/welcome', or '/profile'
  end

  def after_inactive_sign_up_path_for(resource)
    root_path # or a "check your email" page
  end
end
