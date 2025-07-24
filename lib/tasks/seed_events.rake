# frozen_string_literal: true

namespace :db do
  namespace :seed do
    desc "Seed EventLog with sample data"
    task events: :environment do
      # Define event types
      EVENT_TYPES = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]

      # Clear existing records (optional)
      EventLog.delete_all

      # Create sample event logs
      100.times do
        EventLog.create!(
          user_id: Faker::Number.between(from: 1, to: 1000),
          event_type: EVENT_TYPES.sample,
          event_data: {
            action: Faker::Lorem.word,
            details: Faker::Lorem.sentence,
            value: Faker::Number.decimal(l_digits: 2),
          },
          occurred_at: Faker::Time.between(from: 30.days.ago, to: Time.current),
          ip_address: Faker::Internet.ip_v4_address,
          user_agent: Faker::Internet.user_agent
        )
      end

      puts "Created #{EventLog.count} EventLog records"
    end
  end
end
