# frozen_string_literal: true

class EventLoggerJob < ApplicationJob
  queue_as :events

  def perform(args)
    user = User.find(args[:user_id])
    
    Event.create!(
      user: user,
      event_type: args[:event_type],
      event_data: args.fetch(:event_data, {}),
      occurred_at: Time.iso8601(args[:occurred_at]),
      ip_address: args[:ip_address],
      user_agent: args[:user_agent]
    )
  rescue StandardError => e
    Rails.logger.error "EventLoggerJob failed: #{e.message}"
    raise e # Re-raise for Sidekiq retry logic
  end

  def self.run_it(args)
    if Rails.env.production?
      EventLoggerJob.perform_later(args)
    else
      EventLoggerJob.perform_now(args)
    end
  end
end
