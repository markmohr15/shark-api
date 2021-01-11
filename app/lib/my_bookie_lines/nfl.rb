class MyBookieLines::Nfl < MyBookieLines::Base

  def self.url
    @url ||= "https://mybookie.ag/sportsbook/nfl/"
  end

  def self.sport
    @sport ||= Sport.nfl
  end

end