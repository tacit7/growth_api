# frozen_string_literal: true

module Api
  module V1
    class UserEventsController < Api::V1::BaseController
      before_action :authenticate_v1_user!

      # GET /v1/user/events
      def index
        page = params[:page]&.to_i || 1
        per_page = [params[:per_page]&.to_i || 25, 100].min
        
        events = current_v1_user.event_logs
                                .includes(:user)
                                .recent
                                .page(page)
                                .per(per_page)

        # Apply filters if provided
        events = events.by_event_type(EventLog::EVENT_TYPES[params[:event_type]]) if params[:event_type].present?
        
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

      # GET /v1/user/events/summary
      def summary
        cache_key = "user-events-summary:#{current_v1_user.id}:#{Date.current}"
        
        summary_data = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
          {
            total_events: current_v1_user.event_logs.count,
            events_today: current_v1_user.event_logs.where(occurred_at: Date.current.all_day).count,
            events_this_week: current_v1_user.event_logs.where(occurred_at: 1.week.ago..Time.current).count,
            event_breakdown: current_v1_user.event_logs.event_counts_by_type,
            recent_activity: current_v1_user.event_logs.recent.limit(10).map { |event| serialize_event(event) },
            top_pages: current_v1_user.event_logs.page_views
                                    .where("metadata ? 'page_path'")
                                    .group("metadata->>'page_path'")
                                    .count
                                    .sort_by { |k, v| -v }
                                    .first(5)
                                    .to_h
          }
        end

        render json: {
          status: 'success',
          data: summary_data
        }
      end

      private

      def serialize_event(event)
        {
          id: event.id,
          event_type: event.event_name,
          metadata: event.metadata,
          occurred_at: event.occurred_at.iso8601,
          ip_address: event.ip_address,
          user_agent: event.user_agent
        }
      end
    end
  end
end