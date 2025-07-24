module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      skip_before_action :verify_authenticity_token
      respond_to :json

      def create
        build_resource(sign_up_params)

        resource.save
        if resource.persisted?
          if resource.active_for_authentication?
            sign_up(resource_name, resource)
            render json: {
              message: 'Success',
              user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
            }, status: :created
          else
            expire_data_after_sign_in!
            render json: { message: 'Signed up. Inactive.' }, status: :ok
          end
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation, :name)
      end
    end
  end
end
