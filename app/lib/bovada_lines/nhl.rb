class BovadaLines::Nhl < BovadaLines::Base

  URL = "https://www.bovada.lv/services/sports/event/coupon/events/A/description/hockey/nhl?marketFilterId=def&preMatchOnly=true&lang=en"

  def self.sport
    @sport ||= Sport.nhl
  end

end