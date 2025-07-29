# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AnalyticsController < Api::V1::BaseController
        before_action :authenticate_v1_user!
        before_action :ensure_admin!

        def dashboard
          render json: {
            total_users: User.count,
            premium_users: User.premium.count,
            conversion_rate: AnalyticsService.conversion_funnel[:conversion_rate],
            events_today: Event.where(occurred_at: Date.current.all_day).count,
            top_events: Event.group(:event_type).count.sort_by(&:last).reverse.first(5).to_h,
            retention_rate: AnalyticsService.new.retention_rate,
            generated_at: Time.current.iso8601
          }
        end

        def events
          events = Event.includes(:user).order(occurred_at: :desc)
          events = events.where(event_type: params[:event_type]) if params[:event_type].present?
          events = events.where('occurred_at >= ?', params[:date_from]) if params[:date_from].present?
          
          events = events.page(params[:page]).per(50)
          
          render json: {
            events: events.map(&method(:serialize_admin_event)),
            pagination: {
              current_page: events.current_page,
              total_pages: events.total_pages,
              total_count: events.total_count
            }
          }
        end

        private

        def ensure_admin!
          unless current_v1_user.admin?
            render json: { error: 'Admin access required' }, status: :forbidden
          end
        end

        def serialize_admin_event(event)
          {
            id: event.id,
            user_email: event.user.email,
            event_type: event.event_type,
            event_data: event.event_data,
            occurred_at: event.occurred_at.iso8601,
            ip_address: event.ip_address
          }
        end
      end
    end
  end
end
