# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do
  let(:user) { create(:user) }

  describe 'POST /v1/login' do
    context 'with valid credentials' do
      let(:params) do
        {
          user: {
            email:    user.email,
            password: user.password,
          },
        }
      end

      it 'logs in and returns JWT token' do
        post '/v1/login', params: params.to_json, headers: json_headers

        json = JSON.parse(response.body)
        expect(json['message']).to eq('Logged in successfully')
        expect(json['user']).to be_a(Hash)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid credentials' do
      let(:bad_params) do
        {
          user: {
            email:    user.email,
            password: 'wrongpass',
          },
        }
      end

      it 'returns unauthorized' do
        post '/v1/login', params: bad_params.to_json, headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /v1/logout' do
    it 'logs out successfully' do
      # First login to get token
      post '/v1/login', params: {
        user: {
          email: user.email,
          password: 'securepass',
        },
      }

      token = JSON.parse(response.body)['token']

      delete '/v1/logout', headers: { 'Authorization' => "Bearer #{token}" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Logged out successfully')
    end
  end
end
