# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  enum :role, [ :user, :admin ]
  enum :subscription_type, [ :free, :premium ]

  has_many :events, class_name: "EventLog", dependent: :destroy

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
end
