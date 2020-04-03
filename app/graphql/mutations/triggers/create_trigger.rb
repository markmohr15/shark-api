module Mutations
  module Triggers
    class CreateTrigger < Mutations::BaseMutation


      argument :operator, Integer, required: true
      argument :target, Float, required: true
      argument :wager_type, Integer, required: true
      argument :game_id, ID, required: true
      argument :team_id, ID, required: true

      field :trigger, Types::TriggerType, null: true
      field :errors, [String], null: false

      def resolve(game_id: nil, team_id: nil, operator: nil, wager_type: nil, target: nil)
        trigger = Trigger.new operator: operator,
                              target: target,
                              wager_type: wager_type,
                              game_id: game_id,
                              team_id: team_id

        if trigger.save
          {
            trigger: trigger,
            errors: [],
          }
        else
          {
            trigger: nil,
            errors: trigger.errors.full_messages
          }
        end
      end

    end
  end
end