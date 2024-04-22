class CaesarsLines::Mlb < CaesarsLines::Base

  def self.url
    "https://api.americanwagering.com/regions/us/locations/ia/brands/czr/sb/v3/sports/baseball/events/schedule?competitionIds=04f90892-3afa-4e84-acce-5b89f151063d"
  end

  def self.sport
    @sport ||= Sport.mlb
  end

end