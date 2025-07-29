# frozen_string_literal: true

class EventLogService
  # Public: Logs an event for a user.
  #
  # user        - The User instance
  # event_type  - An Integer or Symbol identifying the type of event.
  # event_data  - A Hash of metadata (default: empty hash).
  # occurred_at - Time the event occurred (default: Time.current).
  # request     - Optional ActionDispatch::Request to extract IP/User-Agent.
  #
  # Returns the created EventLog document.
  def self.log_event(user:, event_type:, event_data: {}, occurred_at: Time.current, request: nil)
    EventLog.create!(
      user_id:     user&.id,
      event_type:  normalize_event_type(event_type),
      event_data:  event_data,
      occurred_at: occurred_at,
      ip_address:  request&.remote_ip,
      user_agent:  request&.user_agent
    )
  end

  # Public: Retrieves a list of recent events for a user.
  #
  # user  - The User instance.
  # limit - Max number of records to return.
  #
  # Returns a Mongoid::Criteria.
  def self.user_events(user, limit: 50)
    EventLog.where(user_id: user.id).desc(:occurred_at).limit(limit)
  end

  # Public: Generates a summary of events for analytics.
  #
  # days - Integer number of days to look back (default: 7).
  #
  # Returns an array of hashes with :event_type and :count.
  def self.analytics_summary(days: 7)
    from = Time.current - days.days

    EventLog.collection.aggregate([
      { '$match' => { occurred_at: { '$gte' => from } } },
      { '$group' => {
          _id: '$event_type',
          count: { '$sum' => 1 },
        },
      },
      { '$sort' => { count: -1 } },
    ]).map do |doc|
      { event_type: doc['_id'], count: doc['count'] }
    end
  end

  private

  # Internal: Normalize event_type to integer if using symbols.
  def self.normalize_event_type(event_type)
    return event_type if event_type.is_a?(Integer)

    # Map symbol/string to enum-like integer
    {
      page_view: 0,
      click:     1,
      signup:    2,
      subscribe: 3,
    }[event_type.to_sym] || -1
  end
end
