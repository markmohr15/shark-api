class BookmakerLines::Cbb < BookmakerLines::Base

  def self.url
    @url ||= "https://www.bookmaker.eu/live-lines/basketball/college-basketball"
  end

  def self.sport
    @sport ||= Sport.cbb
  end
  
end