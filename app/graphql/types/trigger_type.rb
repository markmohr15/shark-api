module Types
  class TriggerType < Types::BaseObject
    field :id, ID, null: false
    field :operator, String, null: false
    field :status, String, null: false
    field :target, Float, null: false
    field :wager_type, String, null: false
    field :game, Types::GameType, null: false
    field :team, Types::TeamType, null: false
    field :user, Types::UserType, null: false
  end
end
