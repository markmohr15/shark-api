module Types
  class TriggerType < Types::BaseObject
    field :id, ID, null: false
    field :operator, BaseEnum, null: false
    field :status, BaseEnum, null: false
    field :target, Float, null: false
    field :wager_type, BaseEnum, null: false
    field :game, Types::GameType, null: false
    field :team, Types::TeamType, null: false
  end
end
