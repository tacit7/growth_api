# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :user
  enum event_type: {
    user_login: 0,
    user_logout: 1,
    user_registration: 2,

    subscription_upgraded: 10,
    subscription_downgraded: 11,

    profile_updated: 20,

    admin_login: 30,
    user_suspended: 31,
    user_unsuspended: 32,

    rate_limit_exceeded: 42,
    security_breach_detected: 43,
  }

  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }
  scope :authentication_events, -> { where(event_type: [ 0..5 ]) }
  scope :subscription_events, -> { where(event_type: [ 10..14 ]) }
end
