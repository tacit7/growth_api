# frozen_string_literal: true

module AuthHelper
  def auth_headers_for(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first

    {
      'Authorization' => "Bearer #{token}",
      "Accept"        => "application/json",
      "Content-Type"  => "application/json",
    }
  end

  def json_headers
    {
      "accept"        => "application/json",
      "content-type"  => "application/json",
    }
  end
end
