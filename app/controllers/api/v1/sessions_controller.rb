# frozen_string_literal: true

module Api
  module V1
    class SessionsController < Devise::SessionsController
      include RateLimitable

      before_action :check_limit, only: :create
      skip_before_action :verify_authenticity_token
      respond_to :json

      def create
        resource = User.find_by(email: create_params[:email])

        if resource.valid_password?(create_params[:password])
          respond_with(resource, location: nil)
        else
          render json: { message: 'Invalid email or password' }, status: :unauthorized
        end
      end

      private

      def check_limit
        limit_rate("login:#{request.remote_ip}", limit: 5, period: 60)
      end
      def respond_with(resource, _opts = {})
        token = request.env['warden-jwt_auth.token']
        resource.update(jti: token)
        render json: {
          message: 'Logged in successfully',
          user: UserSerializer.new(resource).serializable_hash,
          token: token,
        }, status: :ok
      end

      def respond_to_on_destroy
        render json: { message: 'Logged out successfully' }, status: :ok
      end

      private

      def create_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
