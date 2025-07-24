# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.2", ">= 7.2.2.1"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "factory_bot_rails"  # test data factories
  gem "faker"              # fake test data
  gem 'htmlbeautifier'
  gem "ruby-lsp"
  gem 'pry-rails'
  gem 'pry-byebug'
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-packaging"
  gem "rubocop-performance"
  gem "rubocop-rspec"
  gem "rubocop-shopify"
  gem "rubocop-thread_safety"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

gem "devise"             # user auth for HTML and API
gem "devise-jwt"         # stateless JWT tokens
gem "bcrypt", "~> 3.1.7" # password hashing

# API and frontend integration
gem "rack-cors"          # enable cross-origin requests
gem "jsonapi-serializer" # fast JSON:API compliant serializer

gem "mongo", "~> 2.21"

gem "mongoid", "~> 9.0"
# Utilities
gem "redis"              # caching and pub/sub
gem "dotenv-rails"       # env vars for dev/test
gem 'kaminari'           # pagination
gem 'kaminari-mongoid'   # pagination

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "rspec-rails"        # testing framework
  gem "capybara"
  gem "selenium-webdriver"
end

gem "sidekiq", "~> 8.0"
gem 'pundit'

gem "rest-client", "~> 2.1"

gem "dockerfile-rails", ">= 1.7", :group => :development
