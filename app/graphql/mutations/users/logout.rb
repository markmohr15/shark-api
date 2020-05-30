module Mutations
  module Users
    class Logout < Mutations::BaseMutation

      null true
      description "Logout for users"
      payload_type Boolean

      def resolve
        if context[:current_user]
          context[:current_user].update(jti: SecureRandom.uuid)
          return true
        end 
        false
      end

    end
  end
end