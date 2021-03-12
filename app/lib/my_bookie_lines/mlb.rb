class MyBookieLines::Mlb < MyBookieLines::Base

  def self.url
    @url ||= "https://mybookie.ag/sportsbook/mlb/"
  end

  def self.sport
    @sport ||= Sport.mlb
  end

end