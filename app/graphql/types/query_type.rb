module Types
  class QueryType < Types::BaseObject
    field :me, resolver: Resolvers::Me
    field :all_sports, [Types::SportType], null: false
    field :sportsbooks, [Types::SportsbookType], null: true
    field :game, Types::GameType, null: true do
      argument :id, Integer, required: true
    end
    field :team, Types::TeamType, null: true do
      argument :id, Integer, required: true
    end
    field :trigger, Types::TriggerType, null: true do
      argument :id, Integer, required: true
    end
    field :triggers, [Types::TriggerType], null: true do
      argument :sport_id, Integer, required: false 
      argument :status, String, required: false 
      argument :date, String, required: false
    end
    field :games_by_sport_and_date, [Types::GameType], null: true do
      argument :sport_id, Integer, required: true 
      argument :date, String, required: true
      argument :status, String, required: true, default_value: "Open"
    end
    field :trigger_notifications, [Types::TriggerType], null: true

    def sportsbooks
      if context[:current_user]
        context[:current_user].sportsbooks.active
      else
        raise GraphQL::ExecutionError, "Authentication Error"
      end
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

    def triggers sport_id:, status:, date: 
      if status.present? && Trigger.allowed_scopes.exclude?(status.downcase)
        raise GraphQL::ExecutionError, "Status Error" and return
      end
      if context[:current_user]
        triggers = context[:current_user].triggers
        if status.present?
          triggers = triggers.send(status.downcase)
        end
        if date.present?
          triggers = triggers.where('triggers.gametime >= ? and
                                     triggers.gametime <= ?', 
                                     date.to_date.beginning_of_day, 
                                     date.to_date.end_of_day)
        end
        if sport_id.present?
          triggers = triggers.joins(:game)
                             .where('games.sport_id = ?', sport_id)
        end
        triggers.order(:gametime, :created_at)
      else
        raise GraphQL::ExecutionError, "Authentication Error"
      end
    end

    def games_by_sport_and_date sport_id:, date:, status:
      if status == "Open"
        games = Game.Scheduled
      else
        games = Game.all
      end
      games.where('sport_id = ? and
                  games.gametime >= ? and
                  games.gametime <= ?', 
                  sport_id, date.to_date.beginning_of_day, date.to_date.end_of_day)
            .order(:status, :gametime, :visitor_rot)
    end

    def trigger_notifications
      if context[:current_user]
        triggers = context[:current_user].triggers.where(notified: false, status: "triggered")        
        MarkTriggersNotifiedWorker.perform_async(triggers.pluck :id)
        triggers
      else
        raise GraphQL::ExecutionError, "Authentication Error"
      end
    end
  end
end
