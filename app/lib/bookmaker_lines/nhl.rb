class BookmakerLines::Nhl < BookmakerLines::Base

  def self.url
    @url ||= "https://www.bookmaker.eu/live-lines/hockey/nhl"
  end

  def self.sport
    @sport ||= Sport.nhl
  end

end