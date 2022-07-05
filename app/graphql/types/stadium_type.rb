module Types
  class StadiumType < Types::BaseObject
    field :id, ID, null: false
    field :active, Boolean, null: false
    field :altitude, Integer, null: true
    field :capacity, Integer, null: true
    field :center_field, Integer, null: true
    field :city, String, null: true
    field :country, String, null: true
    field :geo_lat, Float, null: true
    field :geo_lng, Float, null: true
    field :home_plate_direction, Integer, null: true
    field :left_center_field, Integer, null: true
    field :left_field, Integer, null: true
    field :mid_left_center_field, Integer, null: true
    field :mid_left_field, Integer, null: true
    field :mid_right_center_field, Integer, null: true
    field :mid_right_field, Integer, null: true
    field :name, String, null: true
    field :right_center_field, Integer, null: true
    field :right_field, Integer, null: true
    field :stadium_type, String, null: true
    field :state, String, null: true
    field :surface, String, null: true
    field :sport, Types::SportType, null: false
    field :capacity_to_s, String, null: false
    field :roof_status_link, String, null: true
  end
end
