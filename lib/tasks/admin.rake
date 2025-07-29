# frozen_string_literal: true

namespace :admin do
  desc "Create an admin user with email and password"
  task create: :environment do
    email = ENV['EMAIL'] || ask("Admin Email: ")
    password = ENV['PASSWORD'] || ask("Password (min 6 chars): ") { |q| q.echo = "*" }

    unless email.present? && password.present?
      puts "Email and password are required."
      exit 1
    end

    user = User.find_or_initialize_by(email: email)
    user.password = password
    user.password_confirmation = password
    user.role = :admin if user.respond_to?(:role)
    user.subscription_type ||= :free

    if user.save
      puts "Admin user created: #{user.email}"
    else
      puts "Failed to create admin user:"
      user.errors.full_messages.each { |msg| puts "  - #{msg}" }
    end
  end
end
