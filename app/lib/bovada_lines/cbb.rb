class BovadaLines::Cbb < BovadaLines::Base

  URL = "https://www.bovada.lv/services/sports/event/coupon/events/A/description/basketball/college-basketball?marketFilterId=def&preMatchOnly=true&lang=en"

  def self.sport
    @sport ||= Sport.cbb
  end

end