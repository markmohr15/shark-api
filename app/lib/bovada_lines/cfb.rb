class BovadaLines::Cfb < BovadaLines::Base

  URL = "https://www.bovada.lv/services/sports/event/coupon/events/A/description/football/college-football?marketFilterId=def&preMatchOnly=true&eventsLimit=50&lang=en"

  def self.sport
    @sport ||= Sport.cfb
  end

end