module Types
  class SeasonType < Types::BaseObject
    field :id, Integer, null: false
    field :active, Boolean, null: false
    field :end_date, GraphQL::Types::ISO8601Date, null: false
    field :name, String, null: false
    field :start_date, GraphQL::Types::ISO8601Date, null: false
    field :sport, Types::SportType, null: false
    field :games, [Types::GameType], null: false

  end
end
