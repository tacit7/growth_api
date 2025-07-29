# frozen_string_literal: true

module RateLimitable
  extend ActiveSupport::Concern

  private

  def limit_rate(key, limit:, period:)
    limiter = RateLimiter.new(key: key, limit: limit, period: period)

    unless limiter.allowed?
      render json: { error: 'Rate limit exceeded.' }, status: :too_many_requests
      return false
    end

    true
  end
end
