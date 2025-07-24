# app/controllers/concerns/rate_limitable.rb
module RateLimitable
  extend ActiveSupport::Concern

  included do
  end

  # Call inside a controller as a before_action
  def limit_rate(key, limit:, period:)
    limiter = ::RateLimiter.new(key: key, limit: limit, period: period)

    unless limiter.allowed?
      render json: { error: 'Rate limit exceeded. Please try again later.' }, status: :too_many_requests
    end
  end
end
