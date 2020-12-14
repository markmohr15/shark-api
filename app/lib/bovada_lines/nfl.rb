class BovadaLines::Nfl < BovadaLines::Base

  def self.url
    @url ||= "https://www.bovada.lv/services/sports/event/coupon/events/A/description/football/nfl?marketFilterId=def&preMatchOnly=true&lang=en"
  end

  def self.sport
    @sport ||= Sport.find_by_abbreviation "NFL"
  end

  def self.team name
    sport.teams.find_by_bovada_name name
  end

end