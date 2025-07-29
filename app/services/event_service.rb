# frozen_string_literal: true

class EventService
  def self.log_event(user: nil, event_type:, request: nil, occurred_at: Time.current, event_data: {})
    new.log_event(user: user, event_type: event_type, request: request, event_data: event_data, occurred_at: occurred_at)
  end

  def log_event(user:, event_type:, request:, event_data: {}, occurred_at: Time.current)
    Event.create!(
      user: user,
      event_type: event_type,
      event_data: event_data,
      occurred_at: occurred_at,
      ip_address: request&.remote_ip,
      user_agent: request&.user_agent
    )
  end

  def user_events(user, limit: 50)
    user.events.order(occurred_at: :desc).limit(limit)
  end

  def analytics_summary(date_range: 7.days.ago..Time.current)
    Event.where(occurred_at: date_range)
    .group(:event_type)
    .count
  end
end
