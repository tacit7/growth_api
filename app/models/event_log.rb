# frozen_string_literal: true

class EventLog
  EVENT_TYPE_NAMES = {
    1 => "Page View",   2 => "Click",  3 => "Signup",
    4 => "Login",       5 => "Logout", 6 => "Subscribe",
    7 => "Unsubscribe", 8 => "Upgrade Plan",
    9 => "Downgrade Plan",
    10 => "Delete Account"
  }.freeze

  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user, optional: true

  validates :event_type, presence: true, inclusion: { in: EVENT_TYPE_NAMES.keys }
  validates :occurred_at, presence: true

  field :user_id,     type: Integer
  field :event_type,  type: Integer
  field :event_data,  type: Hash
  field :occurred_at, type: Time
  field :ip_address,  type: String
  field :user_agent,  type: String

  index({ user_id: 1 })
  index({ event_type: 1 })
  index({ occurred_at: -1 })
  index({ ip_address: 1 })

  def event_name
    EVENT_TYPE_NAMES[event_type]
  end
end
