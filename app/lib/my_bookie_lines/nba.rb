class MyBookieLines::Nba < MyBookieLines::Base

  def self.url
    @url ||= "https://mybookie.ag/sportsbook/nba/"
  end

  def self.sport
    @sport ||= Sport.nba
  end

end