# frozen_string_literal: true

module Admin
  class DashboardController < ApplicationController
    include Pundit
    before_action :authenticate_admin!

    def index
      @metrics = {
        total_users: User.count,
        premium_users: User.premium.count,
        events_today: Event.where(occurred_at: Date.current.all_day).count,
        top_events: Event.group(:event_type).count.sort_by(&:last).reverse.first(5),
        user_growth: AnalyticsService.user_growth_data(30),
        conversion_funnel: AnalyticsService.conversion_funnel,
        retention_rate: AnalyticsService.new.retention_rate
      }
    end

    private

    def authenticate_admin!
      authorize [ :admin, :dashboard ]
    end
  end
end
