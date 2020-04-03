module Mutations
  module Triggers
    class DestroyTrigger < Mutations::BaseMutation

      argument :id, ID, required: true

      field :trigger, Types::TriggerType, null: true
      field :errors, [String], null: false

      def resolve id:
        trigger = Trigger.find id
        if trigger.destroy
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