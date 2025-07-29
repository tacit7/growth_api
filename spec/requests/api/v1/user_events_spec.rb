# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::UserEvents', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { { 'Authorization' => "Bearer #{jwt_token_for(user)}" } }
  
  before do
    create_list(:event, 5, user: user, event_type: :page_view)
    create_list(:event, 3, user: user, event_type: :login)
  end

  describe 'GET /v1/events' do
    context 'with valid authentication' do
      it 'returns user events with pagination' do
        get '/v1/events', headers: auth_headers
        
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['events']).to be_an(Array)
        expect(json['events'].length).to eq(8)
        expect(json['pagination']).to include('current_page', 'total_pages', 'total_count')
      end

      it 'filters by event type' do
        get '/v1/events', params: { event_type: 'login' }, headers: auth_headers
        
        json = JSON.parse(response.body)
        expect(json['events'].length).to eq(3)
        expect(json['events'].all? { |e| e['event_type'] == 'login' }).to be true
      end

      it 'filters by date range' do
        recent_event = create(:event, user: user, occurred_at: 1.day.ago)
        old_event = create(:event, user: user, occurred_at: 1.week.ago)
        
        get '/v1/events', params: { date_from: 2.days.ago.iso8601 }, headers: auth_headers
        
        json = JSON.parse(response.body)
        event_ids = json['events'].map { |e| e['id'] }
        expect(event_ids).to include(recent_event.id)
        expect(event_ids).not_to include(old_event.id)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        get '/v1/events'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  private

  def jwt_token_for(user)
    Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  end
end
