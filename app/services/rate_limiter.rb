# frozen_string_literal: true

class RateLimiter
  def self.check(user_id:, action:, limit: 100, window: 1.hour)
    new.check(user_id: user_id, action: action, limit: limit, window: window)
  end

  def check(user_id:, action:, limit:, window:)
    key = "rate_limit:#{user_id}:#{action}"
    current = Redis.current.get(key).to_i
    
    if current >= limit
      false
    else
      Redis.current.multi do |pipeline|
        pipeline.incr(key)
        pipeline.expire(key, window.to_i)
      end
      true
    end
  rescue Redis::BaseError => e
    Rails.logger.error "Rate limiter Redis error: #{e.message}"
    true # Fail open - allow request if Redis is down
  end
end
