# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RateLimiter, type: :service do
  let(:user_id) { 123 }
  let(:action) { 'test_action' }
  let(:key) { "rate_limit:#{user_id}:#{action}" }

  before do
    Redis.current.flushdb
  end

  describe '.check' do
    it 'allows requests under the limit' do
      expect(RateLimiter.check(user_id: user_id, action: action, limit: 5, window: 1.hour)).to be true
    end

    it 'blocks requests over the limit' do
      5.times { RateLimiter.check(user_id: user_id, action: action, limit: 5, window: 1.hour) }
      expect(RateLimiter.check(user_id: user_id, action: action, limit: 5, window: 1.hour)).to be false
    end

    it 'fails open when Redis is unavailable' do
      allow(Redis.current).to receive(:get).and_raise(Redis::BaseError)
      expect(RateLimiter.check(user_id: user_id, action: action)).to be true
    end
  end
end
