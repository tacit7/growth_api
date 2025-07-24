class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  enum :role, [:user, :admin]
  enum :subscription_type, [:free , :premium]

  has_many :events, class_name: "Event", dependent: :destroy

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :trackable, :jwt_authenticatable,
  jwt_revocation_strategy: self
end
