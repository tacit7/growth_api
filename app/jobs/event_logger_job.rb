# frozen_string_literal: true

class EventLoggerJob < ApplicationJob
  queue_as :events

  def perform(args)
    EventLog.create!(
      user_id:     args[:user_id],
      event_type:  args[:event_type],
      event_data:  args.fetch(:event_data, {}),
      occurred_at: Time.iso8601(args[:occurred_at]),
      ip_address:  args[:ip_address],
      user_agent:  args[:user_agent]
    )
  end

  def self.run_it(args)
    if Rails.env.production?
      EventLoggerJob.perform_later(args)
    else
      EventLoggerJob.perform_now(args)
    end
  end
end
