class UserSerializer
  include JSONAPI::Serializer

  set_type :user
  attributes :id, :email, :created_at, :updated_at, :role, :subscription_type
end
