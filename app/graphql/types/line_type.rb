module Types
  class LineType < Types::BaseObject
    field :id, ID, null: false
    field :home_ml, Integer, null: true
    field :home_rl, Integer, null: true
    field :home_spread, Float, null: true
    field :over_odds, Integer, null: true
    field :total, Float, null: true
    field :under_odds, Integer, null: true
    field :visitor_ml, Integer, null: true
    field :visitor_rl, Integer, null: true
    field :visitor_spread, Float, null: true
    field :display_home_spread, String, null: false
    field :display_visitor_spread, String, null: false
    field :display_home_rl, String, null: false
    field :display_visitor_rl, String, null: false
    field :display_home_ml, String, null: false
    field :display_visitor_ml, String, null: false
    field :display_over, String, null: false
    field :display_under, String, null: false
    field :display_over_odds, String, null: false
    field :display_under_odds, String, null: false
    field :game, Types::GameType, null: false
    field :sportsbook, Types::SportsbookType, null: false
  end
end
