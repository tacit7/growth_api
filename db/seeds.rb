# Growth API Seed Data
# This file creates realistic test data for development and testing
# Run with: rails db:seed

puts "🌱 Starting to seed the Growth API database..."

# Clear existing data to ensure clean seeding
puts "🧹 Cleaning existing data..."
EventLog.delete_all if defined?(EventLog)
User.delete_all

puts "👥 Creating users with different roles and subscription types..."

# Create 1 admin user - this user will have elevated privileges
admin_user = User.create!(
  email: "admin@growthapi.com",
  name: "Sarah Administrator",
  password: "password123",
  password_confirmation: "password123",
  role: :admin,
  subscription_type: :premium,
  created_at: 6.months.ago
)

puts "✅ Created admin user: #{admin_user.name} (#{admin_user.email})"

# Create 4 regular users with varying subscription types and join dates
regular_users = []

user_data = [
  {
    name: "Marcus Developer",
    email: "marcus@example.com",
    subscription_type: :premium,
    created_at: 3.months.ago
  },
  {
    name: "Lisa Designer", 
    email: "lisa@example.com",
    subscription_type: :free,
    created_at: 2.months.ago
  },
  {
    name: "James Product Manager",
    email: "james@example.com", 
    subscription_type: :premium,
    created_at: 1.month.ago
  },
  {
    name: "Emma Marketing",
    email: "emma@example.com",
    subscription_type: :free,
    created_at: 2.weeks.ago
  }
]

user_data.each do |user_info|
  user = User.create!(
    email: user_info[:email],
    name: user_info[:name],
    password: "password123",
    password_confirmation: "password123",
    role: :user,
    subscription_type: user_info[:subscription_type],
    created_at: user_info[:created_at]
  )
  
  regular_users << user
  puts "✅ Created user: #{user.name} (#{user.subscription_type} subscription)"
end

# Combine all users for event generation
all_users = [admin_user] + regular_users

puts "📊 Creating 100 realistic events distributed across all users..."

# Define realistic page paths for page view events
page_paths = [
  '/dashboard',
  '/profile', 
  '/analytics',
  '/settings',
  '/billing',
  '/help',
  '/features/premium',
  '/reports/monthly',
  '/api/docs',
  '/integrations'
]

# Create 100 events with realistic distribution
100.times do |i|
  # Select a random user (weighted toward earlier users)
  selected_user = all_users.sample
  
  # Generate a weighted random event type (more page views and clicks)
  event_type = case rand(1..10)
  when 1..4
    EventLog::EVENT_TYPES['Page View']  # 40% page views
  when 5..6
    EventLog::EVENT_TYPES['Click']      # 20% clicks
  when 7
    EventLog::EVENT_TYPES['Login']      # 10% login
  when 8
    EventLog::EVENT_TYPES['Logout']     # 10% logout
  when 9
    EventLog::EVENT_TYPES['Subscribe']  # 10% subscription events
  else
    EventLog::EVENT_TYPES['Signup']     # 10% signups
  end
  
  # Create contextual metadata based on event type
  metadata = case event_type
  when EventLog::EVENT_TYPES['Page View']
    {
      page_path: page_paths.sample,
      referrer: ['direct', 'google.com', 'social_media', 'email_campaign'].sample,
      session_duration: rand(30..1800)
    }
  when EventLog::EVENT_TYPES['Click']
    {
      button_id: ['cta_upgrade', 'save_profile', 'download_report', 'share_content'].sample,
      page_path: page_paths.sample,
      position: { x: rand(0..1920), y: rand(0..1080) }
    }
  when EventLog::EVENT_TYPES['Login'], EventLog::EVENT_TYPES['Logout']
    {
      ip_address: "192.168.1.#{rand(1..255)}",
      device_type: ['desktop', 'mobile', 'tablet'].sample,
      browser: ['Chrome', 'Firefox', 'Safari', 'Edge'].sample
    }
  when EventLog::EVENT_TYPES['Subscribe'], EventLog::EVENT_TYPES['Upgrade Plan']
    {
      from_plan: 'free',
      to_plan: 'premium',
      payment_method: ['credit_card', 'paypal', 'stripe'].sample,
      amount: rand(9..99)
    }
  when EventLog::EVENT_TYPES['Signup']
    {
      registration_source: ['organic', 'referral', 'social', 'email_campaign'].sample,
      utm_source: ['google', 'facebook', 'email', 'direct'].sample
    }
  else
    {
      page_path: page_paths.sample,
      session_id: SecureRandom.hex(8)
    }
  end
  
  # Create realistic timestamp (more recent events)
  created_time = case rand(1..10)
  when 1..3
    rand(1.day.ago..Time.current)        # 30% last day
  when 4..6  
    rand(1.week.ago..1.day.ago)          # 30% last week
  when 7..8
    rand(1.month.ago..1.week.ago)        # 20% last month
  else
    rand(selected_user.created_at..1.month.ago)  # 20% older
  end
  
  # Create the event
  EventLog.create!(
    user: selected_user,
    event_type: event_type,
    metadata: metadata,
    ip_address: "192.168.1.#{rand(1..255)}",
    user_agent: 'Mozilla/5.0 (Seed Data)',
    occurred_at: created_time
  )
  
  # Progress indicator
  print "." if (i + 1) % 10 == 0
end

puts "\n"

# Display summary statistics
puts "🎉 Seeding completed successfully!"
puts "📈 Summary:"
puts "   • Total users created: #{User.count}"
puts "   • Admin users: #{User.where(role: :admin).count}"
puts "   • Regular users: #{User.where(role: :user).count}"  
puts "   • Premium subscribers: #{User.where(subscription_type: :premium).count}"
puts "   • Free subscribers: #{User.where(subscription_type: :free).count}"
puts "   • Total events created: #{EventLog.count}"

# Event breakdown
event_counts = EventLog.event_counts_by_type
puts "   • Event breakdown:"
event_counts.each do |event_name, count|
  puts "     - #{event_name}: #{count}"
end

puts "\n🔑 Login credentials for testing:"
puts "   Admin: admin@growthapi.com / password123"
puts "   Users: marcus@example.com, lisa@example.com, james@example.com, emma@example.com"
puts "   Password for all users: password123"

puts "\n✨ Your Growth API is now ready for development and testing!"
