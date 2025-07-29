# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :user
  # Consolidated event types matching EventLog constants for consistency
  EVENT_TYPES = {
    page_view: 1,
    click: 2,
    signup: 3,
    login: 4,
    logout: 5,
    subscribe: 6,
    unsubscribe: 7,
    upgrade_plan: 8,
    downgrade_plan: 9,
    delete_account: 10,
    profile_updated: 20,
    admin_login: 30,
    user_suspended: 31,
    user_unsuspended: 32,
    rate_limit_exceeded: 42,
    security_breach_detected: 43
  }.freeze

  enum event_type: EVENT_TYPES

  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }
  scope :authentication_events, -> { where(event_type: [ 0..5 ]) }
  scope :subscription_events, -> { where(event_type: [ 10..14 ]) }
end
