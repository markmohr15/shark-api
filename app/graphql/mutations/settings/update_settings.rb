module Mutations
  module Settings
    class UpdateSettings < Mutations::BaseMutation
  
      null true
      description "Update settings for a user"
      payload_type Types::UserType 
      argument :bet_online, Boolean, required: true
      argument :bookmaker, Boolean, required: true
      argument :bovada, Boolean, required: true
      argument :my_bookie, Boolean, required: false

      def resolve(bet_online: nil, bookmaker: nil, bovada: nil, my_bookie: nil)
        if context[:current_user]
          context[:current_user].sportsbooks = []
          if bet_online
            context[:current_user].sportsbooks << Sportsbook.find_by_name('BetOnline')
          end
          if bookmaker
            context[:current_user].sportsbooks << Sportsbook.find_by_name('Bookmaker')
          end
          if bovada
            context[:current_user].sportsbooks << Sportsbook.find_by_name('Bovada')
          end
          if my_bookie
            context[:current_user].sportsbooks << Sportsbook.find_by_name('MyBookie')
          end
          context[:current_user]
        else
          raise GraphQL::ExecutionError, "Invalid Token"
        end
      rescue StandardError => exception
        raise GraphQL::ExecutionError, "There was an issue saving your settings."
      end

    end
  end
end

