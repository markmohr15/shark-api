module Types
  class UserType < Types::BaseObject
    field :email, String, null: true
    field :token, String, null: false
    field :jti, String, null: false
    field :id, ID, null: false
  end
end