class MyBookieLines::Nhl < MyBookieLines::Base

  def self.url
    @url ||= "https://mybookie.ag/sportsbook/nhl/"
  end

  def self.sport
    @sport ||= Sport.nhl
  end

end