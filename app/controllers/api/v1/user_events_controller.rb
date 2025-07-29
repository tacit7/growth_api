# frozen_string_literal: true

module Api
  module V1
    class UserEventsController < Api::V1::BaseController
      before_action :authenticate_v1_user!

      def index
        events = current_v1_user.events.includes(:user)
        events = filter_by_event_type(events) if params[:event_type].present?
        events = filter_by_date_range(events) if date_params_present?
        
        events = events.order(occurred_at: :desc).page(params[:page]).per(25)
        
        render json: {
          events: events.map(&method(:serialize_event)),
          pagination: pagination_meta(events)
        }
      end

      private

      def filter_by_event_type(events)
        return events unless Event::EVENT_TYPES.key?(params[:event_type].to_sym)
        
        events.where(event_type: params[:event_type])
      end

      def filter_by_date_range(events)
        events = events.where('occurred_at >= ?', params[:date_from]) if params[:date_from]
        events = events.where('occurred_at <= ?', params[:date_to]) if params[:date_to]
        events
      end

      def date_params_present?
        params[:date_from].present? || params[:date_to].present?
      end

      def serialize_event(event)
        {
          id: event.id,
          event_type: event.event_type,
          event_data: event.event_data,
          occurred_at: event.occurred_at.iso8601,
          ip_address: event.ip_address&.truncate(15),
          user_agent: event.user_agent&.truncate(50)
        }
      end

      def pagination_meta(events)
        {
          current_page: events.current_page,
          total_pages: events.total_pages,
          total_count: events.total_count,
          per_page: events.limit_value
        }
      end
    end
  end
end
