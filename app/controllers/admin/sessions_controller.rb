module Admin
  class SessionsController < Devise::SessionsController
    # layout 'admin' # Optional: if you have a separate layout for admin

    # GET /admin/login
    def new
      super
    end

    # POST /admin/login
    def create
      super
    end

    # DELETE /admin/logout
    def destroy
      super
    end

    protected

    # After sign in, redirect to admin dashboard
    def after_sign_in_path_for(resource)
      admin_dashboard_path
    end

    # After logout, redirect to login page
    def after_sign_out_path_for(resource_or_scope)
      new_admin_session_path
    end
  end
end
