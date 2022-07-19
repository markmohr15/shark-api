module Mutations
  module Users
    class DestroyUser < Mutations::BaseMutation

      #null true
      description "Delete User"
      payload_type Types::UserType

      def resolve
        if context[:current_user]
          user = context[:current_user]
          if user.destroy
            user
          else
            raise GraphQL::ExecutionError, "Could not delete user - #{user.errors.full_messages.join(", ")}"
          end
        else
          raise GraphQL::ExecutionError, "Invalid Token"
        end
      end

    end
  end
end