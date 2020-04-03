module Types
  class TeamType < Types::BaseObject
    field :id, ID, null: false
    field :active, Boolean, null: false
    field :name, String, null: false
    field :nickname, String, null: true
    field :short_display_name, String, null: true
    field :division, Types::DivisionType, null: true
    field :league, Types::LeagueType, null: true
    field :sport, Types::SportType, null: false
    field :subdivision, Types::SubdivisionType, null: false
    field :games_as_visitor, [Types::GameType], null: false
    field :games_as_home, [Types::GameType], null: false
  end
end




