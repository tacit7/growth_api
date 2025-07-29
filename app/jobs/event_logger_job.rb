# frozen_string_literal: true

class EventLoggerJob < ApplicationJob
  queue_as :events

  def perform(args)
    user = User.find(args[:user_id])
    event_type_id = EventLog::EVENT_TYPES[args[:event_type]] || args[:event_type]
    
    EventLog.create!(
      user: user,
      event_type: event_type_id,
      metadata: args.fetch(:event_data, {}).merge(
        ip_address: args[:ip_address],
        user_agent: args[:user_agent]
      ),
      occurred_at: Time.iso8601(args[:occurred_at])
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
