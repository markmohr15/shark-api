class BookmakerLines::Cfb < BookmakerLines::Base

  def self.url
    @url ||= "https://www.bookmaker.eu/live-lines/football/college-football"
  end

  def self.sport
    @sport ||= Sport.cfb
  end

end