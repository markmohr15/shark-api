module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :all_sports, [Types::SportType], null: false
    field :game, Types::GameType, null: true do
      argument :id, ID, required: true
    end
    field :team, Types::TeamType, null: true do
      argument :id, ID, required: true
    end
    field :trigger, Types::TriggerType, null: true do
      argument :id, ID, required: true
    end
    field :games_by_sport_and_date, [Types::GameType], null: true do
      argument :sport_id, ID, required: true 
      argument :date, GraphQL::Types::ISO8601Date, required: true
    end

    def all_sports
      Sport.active
    end

    def game id:
      Game.find id
    end

    def team id:
      Team.find id
    end

    def trigger id:
      Trigger.find id
    end

    def games_by_sport_and_date sport_id:, date:
      Game.where('sport_id = ? and
                  games.gametime >= ? and
                  games.gametime <= ?', 
                  sport_id, date.beginning_of_day, date.end_of_day)
    end

  end
end
