# frozen_string_literal: true

module Api
  module V1
   class BaseController < ActionController::API
      include ErrorHandling
      before_action :set_api_version
      before_action :authenticate_v1_user!

      private

      def set_api_version
        response.headers['X-API-Version'] = 'v1'
      end


   end
  end
end
