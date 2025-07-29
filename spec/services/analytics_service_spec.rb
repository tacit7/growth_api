# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnalyticsService, type: :service do
  let(:user) { create(:user) }
  
  describe '.user_engagement_score' do
    it 'calculates weighted engagement score' do
      create(:event, user: user, event_type: :page_view, occurred_at: 1.week.ago)
      create(:event, user: user, event_type: :subscribe, occurred_at: 1.week.ago)
      
      score = AnalyticsService.user_engagement_score(user)
      expect(score).to eq(11) # 1 (page_view) + 10 (subscribe)
    end

    it 'returns 0 for users with no recent events' do
      create(:event, user: user, event_type: :page_view, occurred_at: 2.months.ago)
      expect(AnalyticsService.user_engagement_score(user)).to eq(0)
    end
  end

  describe '.conversion_funnel' do
    it 'calculates conversion rate correctly' do
      create_list(:event, 10, event_type: :signup)
      create_list(:event, 3, event_type: :subscribe)
      
      funnel = AnalyticsService.conversion_funnel
      expect(funnel[:signups]).to eq(10)
      expect(funnel[:subscriptions]).to eq(3)
      expect(funnel[:conversion_rate]).to eq(30.0)
    end
  end
end
