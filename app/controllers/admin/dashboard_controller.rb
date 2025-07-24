# frozen_string_literal: true

module Admin
  class DashboardController < ApplicationController
    include Pundit
    before_action :authenticate_admin!

    def index
      @user_count  = User.count
      @event_count = EventLog.count
    end

    private

    def authenticate_admin!
      authorize [ :admin, :dashboard ]
    end
  end
end
