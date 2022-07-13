module Types
  class LeagueType < Types::BaseObject
    field :id, Integer, null: false
    field :abbreviation, String, null: true
    field :active, Boolean, null: false
    field :name, String, null: false
    field :sport, Types::SportType, null: false
    field :teams, [Types::TeamType], null: false
    field :divisions, [Types::DivisionType], null: false
    field :subdivisions, [Types::SubdivisionType], null: false

  end
end
