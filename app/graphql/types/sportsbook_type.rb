module Types
  class SportsbookType < Types::BaseObject
    field :id, Integer, null: false
    field :name, String, null: false
    field :abbreviation, String, null: false
  end
end