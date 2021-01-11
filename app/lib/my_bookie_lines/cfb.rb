class MyBookieLines::Cfb < MyBookieLines::Base

  def self.url
    @url ||= "https://mybookie.ag/sportsbook/college-football/"
  end

  def self.sport
    @sport ||= Sport.cfb
  end

end