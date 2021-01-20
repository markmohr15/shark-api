class BookmakerLines::Nba < BookmakerLines::Base

  def self.url
    @url ||= "https://www.bookmaker.eu/live-lines/basketball/nba"
  end

  def self.sport
    @sport ||= Sport.nba
  end
  
end