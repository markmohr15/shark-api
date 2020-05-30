module Mutations
  module Users
    class ResendUnlockInstructions < Mutations::BaseMutation
  
      null false
      description "Unlock the user account"
      argument :email, String, required: true
      payload_type Boolean

      def resolve(email:)
        user = User.find_by_email(email)
        return false if !user
        user.resend_unlock_instructions
      end

    end
  end
end