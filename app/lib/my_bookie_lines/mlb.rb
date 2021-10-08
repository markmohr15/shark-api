class MyBookieLines::Mlb < MyBookieLines::Base

  def self.url
    @url ||= "https://mybookie.ag/sportsbook/mlb/"
  end

  def self.sport
    @sport ||= Sport.mlb
  end

  def self.team name
    name = name.split(" ")
    sport.tags.find_by_name(name[0..1])&.team || sport.tags.find_by_name(name[0..2])&.team
  end

end