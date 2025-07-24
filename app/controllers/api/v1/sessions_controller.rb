module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json
      skip_before_action :verify_authenticity_token

      private

      def respond_with(resource, _opts = {})
        token = request.env['warden-jwt_auth.token']

        render json: {
          message: 'Logged in successfully',
          user: UserSerializer.new(resource).serializable_hash,
          token: token
        }, status: :ok
      end

      def respond_to_on_destroy
        render json: { message: 'Logged out successfully' }, status: :ok
      end
    end
  end
end
