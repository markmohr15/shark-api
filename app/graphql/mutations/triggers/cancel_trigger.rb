module Mutations
  module Triggers
    class CancelTrigger < Mutations::BaseMutation

      null true
      description "Cancel a trigger"
      payload_type Types::TriggerType
      argument :id, Integer, required: true

      def resolve id:
        if context[:current_user]
          trigger = context[:current_user].triggers.find id
          if trigger&.update status: "canceled"
            trigger
          else
            raise GraphQL::ExecutionError, "Could not cancel trigger - #{trigger.errors.full_messages.join(", ")}"
          end
        else
          raise GraphQL::ExecutionError, "Invalid Token"
        end
      end

    end
  end
end