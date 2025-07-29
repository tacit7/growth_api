# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Events', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { { 'Authorization' => "Bearer #{jwt_token_for(user)}" } }

  describe 'POST /v1/event' do
    let(:valid_params) do
      {
        event_type: 'page_view',
        event_data: { page: '/dashboard', source: 'direct' }
      }
    end

    context 'with valid authentication and params' do
      it 'queues an event successfully' do
        expect {
          post '/v1/event', params: valid_params, headers: auth_headers
        }.to change(Event, :count).by(1)
        
        expect(response).to have_http_status(:accepted)
        expect(JSON.parse(response.body)['message']).to eq('Event queued')
      end

      it 'sets X-API-Version header' do
        post '/v1/event', params: valid_params, headers: auth_headers
        expect(response.headers['X-API-Version']).to eq('v1')
      end
    end

    context 'rate limiting' do
      it 'blocks requests after rate limit exceeded' do
        allow(RateLimiter).to receive(:check).and_return(false)
        
        post '/v1/event', params: valid_params, headers: auth_headers
        expect(response).to have_http_status(:too_many_requests)
      end
    end

    context 'with invalid event type' do
      it 'returns bad request' do
        post '/v1/event', params: { event_type: 'invalid_type' }, headers: auth_headers
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Invalid event_type')
      end
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        post '/v1/event', params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  private

  def jwt_token_for(user)
    Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  end
end
