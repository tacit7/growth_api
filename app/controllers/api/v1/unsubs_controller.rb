# frozen_string_literal: true

module Api
  module V1
    class UnsubsController < Api::V1::BaseController
      def destroy
        if SubscriptionService.downgrade current_v1_user
          render json: { message: 'Success' }, status: :ok
        else
          render json: { error: 'Failure' }, status: :unprocessable_entity
        end
      end
    end
  end
end
