# frozen_string_literal: true

module Api
  module V1
    class EventsController < Api::V1::BaseController
      before_action :authenticate_v1_user!
      before_action :check_rate_limit
      before_action :validate_event_params

      def create
        EventLoggerJob.run_it(
          user_id: current_v1_user.id,
          event_type: sanitized_event_type,
          event_data: sanitized_event_data,
          occurred_at: Time.current.iso8601,
          ip_address: request.remote_ip,
          user_agent: request.user_agent&.truncate(500)
        )

        render json: { message: 'Event queued' }, status: :accepted
      rescue StandardError => e
        Rails.logger.error "Event logging failed: #{e.message}"
        render json: { error: 'Event could not be processed' }, status: :unprocessable_entity
      end

      private

      def validate_event_params
        unless params[:event_type].present?
          render json: { error: 'event_type is required' }, status: :bad_request
          return false
        end

        unless valid_event_type?(params[:event_type])
          render json: { 
            error: 'Invalid event_type', 
            valid_types: Event::EVENT_TYPES.keys 
          }, status: :bad_request
          return false
        end

        true
      end

      def check_rate_limit
        unless RateLimiter.check(user_id: current_v1_user.id, action: 'create_event', limit: 1000, window: 1.hour)
          render json: { error: 'Rate limit exceeded' }, status: :too_many_requests
        end
      end

      def valid_event_type?(event_type)
        Event::EVENT_TYPES.key?(event_type.to_sym) || Event::EVENT_TYPES.value?(event_type.to_i)
      end

      def sanitized_event_type
        params[:event_type]
      end

      def sanitized_event_data
        event_data = params[:event_data] || {}
        
        # Limit metadata size and sanitize
        return {} unless event_data.is_a?(Hash)
        
        sanitized = {}
        event_data.each do |key, value|
          next if sanitized.size >= 10 # Max 10 metadata fields
          
          clean_key = key.to_s.truncate(50)
          clean_value = case value
                       when String
                         value.truncate(1000)
                       when Numeric
                         value
                       when TrueClass, FalseClass
                         value
                       else
                         value.to_s.truncate(1000)
                       end
          
          sanitized[clean_key] = clean_value
        end
        
        sanitized
      end
    end
  end
end
