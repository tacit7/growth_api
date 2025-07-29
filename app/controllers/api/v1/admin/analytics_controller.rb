# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AnalyticsController < Api::V1::BaseController
        before_action :ensure_admin_user

        # GET /v1/admin/analytics/dashboard
        def dashboard
          cache_key = "admin:analytics:dashboard:#{Date.current}"
          
          analytics_data = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
            {
              summary: {
                total_users: User.count,
                premium_users: User.premium.count,
                free_users: User.free.count,
                conversion_rate: calculate_conversion_rate,
                total_events: EventLog.count,
                events_today: EventLog.where(occurred_at: Date.current.all_day).count
              },
              user_growth: user_growth_data,
              event_breakdown: EventLog.event_counts_by_type,
              subscription_metrics: subscription_metrics,
              top_pages: EventLog.top_pages,
              daily_activity: EventLog.daily_event_counts
            }
          end

          render json: {
            status: 'success',
            data: analytics_data,
            generated_at: Time.current.iso8601
          }
        end

        # GET /v1/admin/analytics/events
        def events
          page = params[:page]&.to_i || 1
          per_page = [params[:per_page]&.to_i || 25, 100].min
          
          events = EventLog.includes(:user)
                          .recent
                          .page(page)
                          .per(per_page)

          # Apply filters if provided
          events = events.by_event_type(EventLog::EVENT_TYPES[params[:event_type]]) if params[:event_type].present?
          events = events.where(user: User.where(id: params[:user_id])) if params[:user_id].present?
          
          if params[:date_from].present? && params[:date_to].present?
            events = events.for_date_range(Date.parse(params[:date_from]), Date.parse(params[:date_to]))
          end

          render json: {
            status: 'success',
            data: {
              events: events.map { |event| serialize_event(event) },
              pagination: {
                current_page: page,
                per_page: per_page,
                total_count: events.total_count,
                total_pages: events.total_pages
              }
            }
          }
        end

        private

        def ensure_admin_user
          render json: { error: 'Admin access required' }, status: :forbidden unless current_v1_user&.admin?
        end

        def calculate_conversion_rate
          total_users = User.count
          return 0.0 if total_users.zero?
          
          (User.premium.count.to_f / total_users * 100).round(2)
        end

        def user_growth_data
          30.days.ago.to_date.upto(Date.current).map do |date|
            {
              date: date.iso8601,
              total_users: User.where(created_at: ..date.end_of_day).count,
              new_signups: User.where(created_at: date.all_day).count
            }
          end
        end

        def subscription_metrics
          {
            subscriptions_this_month: User.premium.where(updated_at: Date.current.beginning_of_month..Date.current.end_of_month).count,
            churned_users: 0, # Would need a subscription history table for accurate churn
            mrr: User.premium.count * 29.99, # Assuming $29.99/month
            upgrade_events: EventLog.where(
              event_type: EventLog::EVENT_TYPES['Subscribe'],
              occurred_at: Date.current.beginning_of_month..Date.current.end_of_month
            ).count
          }
        end

        def serialize_event(event)
          {
            id: event.id,
            event_type: event.event_name,
            user: {
              id: event.user.id,
              email: event.user.email,
              subscription_type: event.user.subscription_type
            },
            metadata: event.metadata,
            occurred_at: event.occurred_at.iso8601,
            ip_address: event.ip_address,
            user_agent: event.user_agent
          }
        end
      end
    end
  end
end
