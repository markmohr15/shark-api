class BovadaLines::Nba < BovadaLines::Base

  URL = "https://www.bovada.lv/services/sports/event/coupon/events/A/description/basketball/nba?marketFilterId=def&preMatchOnly=true&lang=en"

  def self.sport
    @sport ||= Sport.nba
  end

end