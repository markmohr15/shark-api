module Types
  class GameType < Types::BaseObject
    field :id, Integer, null: false
    field :channel, String, null: true
    field :conference_game, Boolean, null: false
    field :home_rot, Integer, null: true
    field :home_score, Integer, null: true
    field :neutral, Boolean, null: false
    field :period, Integer, null: true
    field :status, String, null: true
    field :time_left_min, Integer, null: true
    field :time_left_sec, Integer, null: true
    field :visitor_rot, Integer, null: true
    field :visitor_score, Integer, null: true
    field :week, Integer, null: true
    field :gametime, GraphQL::Types::ISO8601DateTime, null: true
    field :home, Types::TeamType, null: false
    field :season, Types::SeasonType, null: false
    field :sport, Types::SportType, null: false
    field :stadium, Types::StadiumType, null: false
    field :visitor, Types::TeamType, null: false
    field :display_time, String, null: false
    field :display_date, String, null: false
    field :total, Float, null: true
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
    field :current_weather, Types::WeatherType, null: true
    field :weather_reports, [Types::WeatherType], null: true
    field :last_lines, [Types::LineType], null: false
    field :datetime_to_s, String, null: false
    
    def display_home_spread
      object.display_home_spread context[:current_user]
    end

    def display_visitor_spread
      object.display_visitor_spread context[:current_user]
    end
    
    def display_home_rl
      object.display_home_rl context[:current_user]
    end
    
    def display_visitor_rl
      object.display_visitor_rl context[:current_user]
    end

    def display_home_ml
      object.display_home_ml context[:current_user]
    end

    def display_visitor_ml
      object.display_visitor_ml context[:current_user]
    end

    def display_over
      object.display_over context[:current_user]
    end

    def display_under
      object.display_under context[:current_user]
    end

    def display_over_odds
      object.display_over_odds context[:current_user]
    end

    def display_under_odds
      object.display_under_odds context[:current_user]
    end

  end
end
