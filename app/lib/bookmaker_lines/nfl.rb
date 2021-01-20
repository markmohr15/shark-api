class BookmakerLines::Nfl < BookmakerLines::Base

  def self.url
    @url ||= "https://www.bookmaker.eu/live-lines/football/nfl"
  end

  def self.sport
    @sport ||= Sport.nfl
  end

end