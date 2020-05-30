module Mutations
  module Users
    class SignUp < Mutations::BaseMutation
  
      null true
      description "Sign up for users"
      argument :attributes, Types::UserInputType, required: true
      payload_type Types::UserType 

      def resolve(attributes:)
        attrs = attributes.to_kwargs
        if attrs[:password] == attrs[:passwordConfirmation]
          attrs.delete(:passwordConfirmation)
          user = User.create(attrs)
          if user.persisted?
            user
          else
            raise GraphQL::ExecutionError, user.errors.full_messages.uniq.join(', ')
          end
        else
          raise GraphQL::ExecutionError, "Password does not match Password Confirmation"
        end
      end

    end
  end
end

