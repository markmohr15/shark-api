module Mutations
  module Users
    class Login < Mutations::BaseMutation

      null true
      description "Login for users"
      argument :email, String, required: true
      argument :password, String, required: true
      payload_type Types::UserType 

      def resolve(email:, password:)
        user = User.find_for_authentication(email: email)
        return nil if !user
        
        is_valid_for_auth = user.valid_for_authentication?{
          user.valid_password?(password)
        }

        return is_valid_for_auth ? user : (raise GraphQL::ExecutionError, 'Wrong Email/Password')
      end

    end
  end
end