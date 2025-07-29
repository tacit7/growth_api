# frozen_string_literal: true

module JwtHelper
  def jwt_token_for(user)
    # This simulates what Devise JWT does internally
    payload = { 'sub' => user.id, 'scp' => 'user', 'aud' => nil, 'iat' => Time.current.to_i, 'exp' => 24.hours.from_now.to_i, 'jti' => user.jti }
    JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key)
  end
end

RSpec.configure do |config|
  config.include JwtHelper
end
