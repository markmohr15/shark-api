module Types
  class MutationType < Types::BaseObject
    field :create_trigger, mutation: Mutations::Triggers::CreateTrigger
    field :update_trigger, mutation: Mutations::Triggers::UpdateTrigger
    field :destroy_trigger, mutation: Mutations::Triggers::DestroyTrigger
  end
end

