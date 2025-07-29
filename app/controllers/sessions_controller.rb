# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  layout 'application' # Use your main HTML layout

  # GET /login
  def new
    super
  end

  # POST /login
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)

    yield resource if block_given?
    redirect_to after_sign_in_path_for(resource)
  end

  # DELETE /logout
  def destroy
    signed_out = sign_out(resource_name)
    flash[:notice] = I18n.t('devise.sessions.signed_out') if signed_out

    yield if block_given?
    redirect_to after_sign_out_path_for(resource_name)
  end

  protected

  def after_sign_in_path_for(resource)
    root_path # or '/profile' or admin_dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # or '/goodbye' page
  end
end
