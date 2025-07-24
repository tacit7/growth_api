# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::BaseController
      def profile
        cache_key = "user-profile:#{current_v1_user.id}:v#{current_v1_user.updated_at.to_i}"

        cached_profile = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
        UserSerializer.new(current_v1_user).serializable_hash
      end

      render json: cached_profile
      end
    end
  end
end
