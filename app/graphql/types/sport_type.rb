module Types
  class SportType < Types::BaseObject
    field :id, Integer, null: false
    field :abbreviation, String, null: false
    field :active, Boolean, null: false
    field :name, String, null: false
    field :leagues, [Types::LeagueType], null: false
    field :divisions, [Types::DivisionType], null: false
    field :subdivisions, [Types::SubdivisionType], null: false
    field :teams, [Types::TeamType], null: false
    field :seasons, [Types::SeasonType], null: false
    field :games, [Types::GameType], null: false
    field :stadiums, [Types::StadiumType], null: false
    field :baseball, Boolean, null: false
    field :weather, Boolean, null: false
  end
end
