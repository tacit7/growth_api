# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::BaseController
      def profile
        render json: UserSerializer.new(current_v1_user).serializable_hash, status: :ok
      end
    end
  end
end
