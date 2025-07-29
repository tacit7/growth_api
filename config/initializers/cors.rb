# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # for dev only

    resource '/v1/*',
      headers: :any,
      expose: [ 'Authorization' ],  # needed for jwt
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      credentials: false
  end
end
