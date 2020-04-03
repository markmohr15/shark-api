module Types
  class GameType < Types::BaseObject
    field :id, ID, null: false
    field :channel, String, null: true
    field :conference_game, Boolean, null: false
    field :home_ml, Integer, null: true
    field :home_rl, Integer, null: true
    field :home_rot, Integer, null: true
    field :home_score, Integer, null: true
    field :neutral, Boolean, null: false
    field :period, Integer, null: true
    field :spread, Float, null: true
    field :status, BaseEnum, null: true
    field :time_left_min, Integer, null: true
    field :time_left_sec, Integer, null: true
    field :total, Float, null: true
    field :time_left_min, Integer, null: true
    field :visitor_ml, Integer, null: true
    field :visitor_rl, Integer, null: true
    field :visitor_rot, Integer, null: true
    field :visitor_score, Integer, null: true
    field :week, Integer, null: true
    field :when, GraphQL::Types::ISO8601DateTime, null: true
    field :home, Types::TeamType, null: false
    field :season, Types::SeasonType, null: false
    field :sport, Types::SportType, null: false
    field :stadium, Types::StadiumType, null: false
    field :visitor, Types::TeamType, null: false
  end
end
