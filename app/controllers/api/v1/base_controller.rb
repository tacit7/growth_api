# frozen_string_literal: true

module Api
  module V1
   class BaseController < ActionController::API
      include RateLimitable
      before_action :authenticate_v1_user!
      before_action :check_rate_limit!

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid,  with: :unprocessable_entity
      # rescue_from Pundit::NotAuthorizedError,   with: :forbidden if defined?(Pundit)

      private
      def check_global_rate_limit!
        # 100 requests per minute per IP across the entire API
        limit_rate("api:#{request.remote_ip}", limit: 5, period: 60)
      end

      def not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def unprocessable_entity(exception)
        render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
      end

      def forbidden(_exception)
        render json: { error: "You're not authorized to perform this action" }, status: :forbidden
      end

      def check_rate_limit!
        key = "api:#{request.remote_ip}"
        limiter = RateLimiter.new(key: key, limit: 5, period: 60) # 100 reqs/min

        unless limiter.allowed?
          render json: { error: 'Rate limit exceeded. Please try again later.' }, status: :too_many_requests
        end
      end
   end
  end
end
