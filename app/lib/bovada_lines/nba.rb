class BovadaLines::Nba < BovadaLines::Base

  def self.url
    @url ||= "https://www.bovada.lv/services/sports/event/coupon/events/A/description/basketball/nba?marketFilterId=def&preMatchOnly=true&lang=en"
  end

  def self.sport
    @sport ||= Sport.find_by_abbreviation "NBA"
  end

end