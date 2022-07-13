module Mutations
  module Triggers
    class CreateTrigger < Mutations::BaseMutation

      null true
      description "Create a trigger"
      payload_type Types::TriggerType
      argument :operator, String, required: true
      argument :target, Float, required: true
      argument :wager_type, String, required: true
      argument :game_id, Integer, required: true
      argument :team_id, Integer, required: false

      def resolve(game_id: nil, team_id: nil, operator: nil, wager_type: nil, target: nil)
        debugger
        if context[:current_user]
          trigger = Trigger.new operator: operator,
                                target: target,
                                wager_type: wager_type,
                                game_id: game_id,
                                team_id: team_id,
                                user: context[:current_user]
          if trigger.save
            trigger
          else
            raise GraphQL::ExecutionError, "Invalid Trigger - #{trigger.errors.full_messages.join(", ")}"
          end
        else
          raise GraphQL::ExecutionError, "Invalid Token"
        end
      end

    end
  end
end