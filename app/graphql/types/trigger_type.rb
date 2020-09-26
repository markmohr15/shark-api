module Types
  class TriggerType < Types::BaseObject
    field :id, ID, null: false
    field :operator, String, null: false
    field :status, String, null: false
    field :target, Float, null: false
    field :wager_type, String, null: false
    field :gametime, GraphQL::Types::ISO8601DateTime, null: true
    field :game, Types::GameType, null: false
    field :team, Types::TeamType, null: true
    field :user, Types::UserType, null: false
    field :display_target, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :tag, String, null: false
  end
end
