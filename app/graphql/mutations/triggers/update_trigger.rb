module Mutations
  module Triggers
    class UpdateTrigger < Mutations::BaseMutation

      argument :id, ID, required: true
      argument :operator, Integer, required: false
      argument :target, Float, required: false
      argument :wager_type, Integer, required: false
      argument :team_id, ID, required: false
      argument :status, Integer, required: false

      field :trigger, Types::TriggerType, null: true
      field :errors, [String], null: false

      def resolve(id:, **attributes)
        trigger = Trigger.find id
        if trigger.update attributes
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