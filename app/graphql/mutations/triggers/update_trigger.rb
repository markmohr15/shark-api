module Mutations
  module Triggers
    class UpdateTrigger < Mutations::BaseMutation

      null true
      description "Update a trigger"
      payload_type Types::TriggerType
      argument :id, Integer, required: true
      argument :operator, String, required: true
      argument :target, Float, required: true
      argument :wager_type, String, required: true
      argument :team_id, Integer, required: false

      def resolve(id: nil, team_id: nil, operator: nil, wager_type: nil, target: nil)
        if context[:current_user]
          trigger = context[:current_user].triggers.find_by_id id
          if trigger.update operator: operator,
                            target: target,
                            wager_type: wager_type,
                            team_id: team_id
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