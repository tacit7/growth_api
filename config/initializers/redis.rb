# frozen_string_literal: true

$redis = Redis.new(
  url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
  timeout: 1,
  reconnect_attempts: 3
)
