class CaesarsLines::Nba < CaesarsLines::Base

  URL = "https://api.americanwagering.com/regions/us/locations/ia/brands/czr/sb/v3/sports/basketball/events/schedule?competitionIds=5806c896-4eec-4de1-874f-afed93114b8c"

  def self.sport
    @sport ||= Sport.nba
  end

end

