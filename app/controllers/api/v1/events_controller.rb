# frozen_string_literal: true

module Api
  module V1
    class EventsController < Api::V1::BaseController
      before_action :authenticate_v1_user!

      def create
        EventLoggerJob.run_it(
          user_id: current_v1_user.id,
          event_type: params[:event_type],
          event_data: params[:event_data],
          occurred_at: Time.current.iso8601,
          ip_address: request.remote_ip,
          user_agent: request.user_agent
        )

        render json: { message: 'Event queued' }, status: :accepted
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end
