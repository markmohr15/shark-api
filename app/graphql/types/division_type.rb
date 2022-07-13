module Types
  class DivisionType < Types::BaseObject
    field :id, Integer, null: false
    field :abbreviation, String, null: false
    field :active, Boolean, null: false
    field :name, String, null: false
    field :league, Types::LeagueType, null: false
    field :teams, [Types::TeamType], null: false
    field :subdivisions, [Types::SubdivisionType], null: false
  end
end
