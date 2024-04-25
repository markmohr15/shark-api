class CaesarsLines::Nhl < CaesarsLines::Base

  URL = "https://api.americanwagering.com/regions/us/locations/ia/brands/czr/sb/v3/sports/icehockey/events/schedule?competitionIds=b7b715a9-c7e8-4c47-af0a-77385b525e09"

  def self.sport
    @sport ||= Sport.nhl
  end

end