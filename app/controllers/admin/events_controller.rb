# frozen_string_literal: true

module Admin
  class EventsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin

    def index
      @events = EventLog.order(occurred_at: :desc).page(params[:page]).per(25)
    end

    private

    def authorize_admin
      authorize [ :admin, :events ]
    end
  end
end
