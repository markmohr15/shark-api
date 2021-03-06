module Types
  class UserInputType < Types::BaseInputObject
    description "Attributes to create a user."
    argument :email, String, 'Email of user', required: true
    argument :password, String, 'Password of user', required: true
    argument :passwordConfirmation, String, 'Password confirmation', required: true
  end
end