class BovadaLines::Cfb < BovadaLines::Base

  def self.url
    @url ||= "https://www.bovada.lv/services/sports/event/coupon/events/A/description/football/college-football?marketFilterId=def&preMatchOnly=true&eventsLimit=50&lang=en"
  end

  def self.sport
    @sport ||= Sport.find_by_abbreviation "CFB"
  end

  def self.team name
    sport.teams.find_by_bovada_name name
  end

end