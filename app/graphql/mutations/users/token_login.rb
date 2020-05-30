module Mutations
  module Users
    class TokenLogin < Mutations::BaseMutation

      null true
      description "JWT token login"
      payload_type Types::UserType 

      def resolve
        context[:current_user]
      end

    end
  end
end