# frozen_string_literal: true

module Api
  module V1
    class EventsController < Api::V1::BaseController
      def create
        result = EventService.log_event(
          user: current_v1_user,
          event_type: event_params[:event_type],
          event_data: event_params[:event_data] || {},
          request: request,
          occurred_at: event_params[:occurred_at],
          event_data: event_params[:event_data] || {}
        )

        if result.persisted?
          render json: { message: "Success" }, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      private

      def event_params
        params.require(:event).permit(:event_type, event_data: {})
      end
    end
  end
end
