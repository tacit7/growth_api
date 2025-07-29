# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email {  "test@example" }
    password { "password" }
    role { :user }
    subscription_type { :free }
  end
end
