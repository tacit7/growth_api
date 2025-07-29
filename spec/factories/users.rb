# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    name { Faker::Name.name }
    role { :user }
    subscription_type { :free }

    trait :admin do
      role { :admin }
    end

    trait :premium do
      subscription_type { :premium }
    end
  end

  factory :event_log do
    association :user
    event_type { EventLog::EVENT_TYPES['Page View'] }
    metadata { { page_path: '/dashboard', referrer: 'google.com' } }
    occurred_at { Time.current }
  end
end
