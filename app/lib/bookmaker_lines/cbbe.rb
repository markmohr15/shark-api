class BookmakerLines::Cbbe < BookmakerLines::Base

  def self.url
    @url ||= "https://www.bookmaker.eu/live-lines/basketball/ncaa(b)extragames"
  end

  def self.sport
    @sport ||= Sport.cbb
  end
  
end