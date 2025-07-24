module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_v1_user!

      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid,  with: :unprocessable_entity
      # rescue_from Pundit::NotAuthorizedError,   with: :forbidden if defined?(Pundit)

      private

      def not_found(exception)
        render json: { error: exception.message }, status: :not_found
      end

      def unprocessable_entity(exception)
        render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
      end

      def forbidden(_exception)
        render json: { error: "You're not authorized to perform this action" }, status: :forbidden
      end
    end
  end
end
