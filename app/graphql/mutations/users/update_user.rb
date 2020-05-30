module Mutations
  module Users
    class UpdateUser < Mutations::BaseMutation

      null true
      description "Update user"
      argument :password, String, required: false
      argument :password_confirmation, String, required: false
      payload_type Types::UserType 

      def resolve(
        password: context[:current_user] ? context[:current_user].password : '',
        password_confirmation: context[:current_user] ? context[:current_user].password_confirmation : ''
      )
        user = context[:current_user]
        return nil if !user
        user.update!(
          password: password,
          password_confirmation: password_confirmation
        )
        user
      end

    end
  end
end