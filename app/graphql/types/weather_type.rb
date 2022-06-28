module Types
  class WeatherType < Types::BaseObject
    field :id, ID, null: false
    field :day, Integer, null: true
    field :dt, GraphQL::Types::ISO8601DateTime, null: false
    field :eve, Integer, null: true
    field :high, Integer, null: true
    field :low, Integer, null: true
    field :morn, Integer, null: true
    field :night, Integer, null: true
    field :report_type, String, null: false
    field :temp, Integer, null: true
    field :weather, String, null: true
    field :wind_deg, Integer, null: true
    field :wind_speed, Integer, null: true
    field :game, Types::GameType, null: false

  end
end
