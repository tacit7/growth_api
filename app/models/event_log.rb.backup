# frozen_string_literal: true

class EventLog < ApplicationRecord
  belongs_to :user

  # Event type constants for better code readability and maintenance
  EVENT_TYPE_NAMES = {
    1 => "Page View",
    2 => "Click",
    3 => "Signup",
    4 => "Login",
    5 => "Logout",
    6 => "Subscribe",
    7 => "Unsubscribe",
    8 => "Upgrade Plan",
    9 => "Downgrade Plan",
    10 => "Delete Account",
  }.freeze

  # Reverse mapping for easy lookup
  EVENT_TYPES = EVENT_TYPE_NAMES.invert.freeze

  # Validations
  validates :event_type, presence: true, inclusion: { in: EVENT_TYPE_NAMES.keys }
  validates :occurred_at, presence: true
  validates :metadata, presence: true

  # Scopes for common queries
  scope :recent, -> { order(occurred_at: :desc) }
  scope :by_event_type, ->(type) { where(event_type: type) }
  scope :page_views, -> { where(event_type: EVENT_TYPES['Page View']) }
  scope :clicks, -> { where(event_type: EVENT_TYPES['Click']) }
  scope :auth_events, -> { where(event_type: [ EVENT_TYPES['Login'], EVENT_TYPES['Logout'], EVENT_TYPES['Signup'] ]) }
  scope :subscription_events, -> { where(event_type: [ EVENT_TYPES['Subscribe'], EVENT_TYPES['Unsubscribe'], EVENT_TYPES['Upgrade Plan'], EVENT_TYPES['Downgrade Plan'] ]) }
  scope :for_date_range, ->(start_date, end_date) { where(occurred_at: start_date..end_date) }

  # Instance methods
  def event_name
    EVENT_TYPE_NAMES[event_type] || "Unknown"
  end

  def page_view?
    event_type == EVENT_TYPES['Page View']
  end

  def click?
    event_type == EVENT_TYPES['Click']
  end

  def auth_event?
    [ EVENT_TYPES['Login'], EVENT_TYPES['Logout'], EVENT_TYPES['Signup'] ].include?(event_type)
  end

  def subscription_event?
    [ EVENT_TYPES['Subscribe'], EVENT_TYPES['Unsubscribe'], EVENT_TYPES['Upgrade Plan'], EVENT_TYPES['Downgrade Plan'] ].include?(event_type)
  end

  # Class methods for analytics
  def self.event_counts_by_type(date_range = nil)
    scope = date_range ? for_date_range(date_range.begin, date_range.end) : all
    scope.group(:event_type)
         .count
         .transform_keys { |type| EVENT_TYPE_NAMES[type] }
  end

  def self.daily_event_counts(days_back = 30)
    where(occurred_at: days_back.days.ago..Time.current)
      .group_by_day(:occurred_at)
      .count
  end

  def self.top_pages(limit = 10)
    page_views
      .where("metadata ? 'page_path'")
      .group("metadata->>'page_path'")
      .count
      .sort_by { |k, v| -v }
      .first(limit)
      .to_h
  end

  # Before callbacks to set defaults
  before_validation :set_occurred_at, on: :create

  private

  def set_occurred_at
    self.occurred_at ||= Time.current
  end
end
