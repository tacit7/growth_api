# frozen_string_literal: true

# RateLimiter provides a basic Redis-backed rate limiting mechanism.
# It tracks request counts using a given key (e.g., user ID or IP address)
# and allows a limited number of requests within a specified time window.
#
# Example:
#   limiter = RateLimiter.new(key: "login:#{request.remote_ip}", limit: 5, period: 60)
#   if limiter.allowed?
#     # proceed with request
#   else
#     # return rate limit error
#   end
class RateLimiter
  def initialize(key:, limit:, period: 10)
    @key = "rate_limit:#{key}"
    @limit = limit
    @period = period # in seconds
  end

  def allowed?
    puts "Checking rate limit for key: #{@key}"
    count = $redis.get(@key).to_i

    if count >= @limit
      false
    else
      increment!
      true
    end
  end

  private

  def increment!
    if $redis.exists(@key)
      $redis.incr(@key)
    else
      $redis.set(@key, 1, ex: @period)
    end
  end
end
