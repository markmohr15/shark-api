module Types
  class MutationType < Types::BaseObject
    # Authentication
    field :login, mutation: Mutations::Users::Login
    field :token_login, mutation: Mutations::Users::TokenLogin
    field :logout, mutation: Mutations::Users::Logout
    field :update_user, mutation: Mutations::Users::UpdateUser
    field :sign_up, mutation: Mutations::Users::SignUp
    field :reset_password, mutation: Mutations::Users::ResetPassword
    field :send_reset_password_instructions, mutation: Mutations::Users::SendResetPasswordInstructions
    field :unlock, mutation: Mutations::Users::Unlock
    field :resend_unlock_instructions, mutation: Mutations::Users::ResendUnlockInstructions
    field :destroy_user, mutation: Mutations::Users::DestroyUser
    
    #Triggers
    field :create_trigger, mutation: Mutations::Triggers::CreateTrigger
    field :update_trigger, mutation: Mutations::Triggers::UpdateTrigger
    field :cancel_trigger, mutation: Mutations::Triggers::CancelTrigger

    #Settings
    field :update_settings, mutation: Mutations::Settings::UpdateSettings
  end
end

