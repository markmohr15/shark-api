class MyBookieLines::Cbb < MyBookieLines::Base

  def self.url
    @url ||= "https://mybookie.ag/sportsbook/ncaa-basketball/"
  end

  def self.sport
    @sport ||= Sport.cbb
  end

end