module Types
  class SubdivisionType < Types::BaseObject
    field :id, ID, null: false
    field :active, Boolean, null: false
    field :name, String, null: false
    field :division, Types::DivisionType, null: false
  end
end
