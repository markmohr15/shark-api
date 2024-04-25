class BovadaLines::Nfl < BovadaLines::Base

  URL = "https://www.bovada.lv/services/sports/event/coupon/events/A/description/football?marketFilterId=def&preMatchOnly=true&lang=en"

  def self.sport
    @sport ||= Sport.nfl
  end

end