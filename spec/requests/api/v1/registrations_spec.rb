# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API::V1::Registrations', type: :request do
  describe 'POST /v1/signup' do
    context 'with valid params' do
      let(:params) do
        {
          user: {
            email: 'test@example.com',
            password: 'password123',
            password_confirmation: 'password123',
          },
        }
      end

      it 'creates a new user and returns a token' do
        post '/v1/signup', params: params.to_json, headers: json_headers

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['user']['email']).to eq('test@example.com')
        expect(response['authorization']).to be_present
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          user: {
            email: 'bad',
            password: 'short',
            password_confirmation: 'wrong',
          },
        }
      end

      it 'returns validation errors' do
        post '/v1/signup', params: params.to_json, headers: json_headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to include(a_string_matching(/Password/))
      end
    end
  end
end
