# frozen_string_literal: true

module Api
  module V1
    class SubscriptionsController < Api::V1::BaseController
      def create
        if SubscriptionService.upgrade current_v1_user
          render json: {
            message: 'Subscription upgraded successfully',
            user: UserSerializer.new(current_v1_user).serializable_hash,
          }, status: :ok
        else
          render json: {
            errors: current_v1_user.errors.full_messages,
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
