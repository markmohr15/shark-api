module Types
  class QueryType < Types::BaseObject
    field :me, resolver: Resolvers::Me
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
      argument :sport_id, Integer, required: true 
      argument :date, String, required: true
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

    def active_triggers
      if context[:current_user]
        current_user.triggers.active
      else
        raise GraphQL::ExecutionError, "Authentication Error"
      end
    end

    def games_by_sport_and_date sport_id:, date:
      Game.where('sport_id = ? and
                  games.gametime >= ? and
                  games.gametime <= ?', 
                  sport_id, date.to_date.beginning_of_day, date.to_date.end_of_day)
    end

  end
end
