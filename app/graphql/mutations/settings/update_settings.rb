module Mutations
  module Settings
    class UpdateSettings < Mutations::BaseMutation
  
      null true
      description "Update settings for a user"
      payload_type Types::UserType 
      argument :bet_online, Boolean, required: true
      argument :pinnacle, Boolean, required: true
      argument :bovada, Boolean, required: true
      argument :draft_kings, Boolean, required: true
      argument :caesars, Boolean, required: false

      def resolve(bet_online: nil, pinnacle: nil, bovada: nil, 
                  draft_kings: nil, caesars: nil)
        if context[:current_user]
          context[:current_user].sportsbooks = []
          if bet_online
            context[:current_user].sportsbooks << Sportsbook.find_by_name('BetOnline')
          end
          if pinnacle
            context[:current_user].sportsbooks << Sportsbook.find_by_name('Pinnacle')
          end
          if bovada
            context[:current_user].sportsbooks << Sportsbook.find_by_name('Bovada')
          end
          if draft_kings
            context[:current_user].sportsbooks << Sportsbook.find_by_name('DraftKings')
          end
          if caesars
            context[:current_user].sportsbooks << Sportsbook.find_by_name('Caesars')
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

