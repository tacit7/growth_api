# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
if Rails.env.development? || Rails.env.production?
  Rails.application.initialize!
end

if Rails.env.test?
  begin
    Rails.application.initialize!
  rescue FrozenError => e
    puts "Tried to modify a frozen object – #{e.message}"
  end
end
