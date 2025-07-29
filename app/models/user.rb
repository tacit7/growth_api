# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  enum :role, [ :user, :admin ]
  enum :subscription_type, [ :free, :premium ]

  # Associations
  has_many :event_logs, dependent: :destroy
  
  # Alias for more natural usage
  alias_method :events, :event_logs

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :jwt_authenticatable, jwt_revocation_strategy: self

  validates :role, presence: true
  validates :subscription_type, presence: true

  after_initialize :set_defaults, if: :new_record?

  def set_defaults
    self.role ||= :user
    self.subscription_type ||= :free
  end
  
  # Event logging convenience methods
  def log_event(event_type, metadata = {}, occurred_at: Time.current)
    event_logs.create!(
      event_type: event_type.is_a?(String) ? EventLog::EVENT_TYPES[event_type] : event_type,
      metadata: metadata,
      occurred_at: occurred_at,
      ip_address: metadata.delete(:ip_address),
      user_agent: metadata.delete(:user_agent)
    )
  end
  
  def recent_events(limit = 10)
    event_logs.recent.limit(limit)
  end
  
  def page_views
    event_logs.page_views
  end
  
  def subscription_events
    event_logs.subscription_events
  end
end
