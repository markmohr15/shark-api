class BovadaLines::Mlb < BovadaLines::Base

  def self.url
    @url ||= "https://www.bovada.lv/services/sports/event/coupon/events/A/description/hockey?marketFilterId=def&preMatchOnly=true&eventsLimit=50&lang=en"
  end

  def self.sport
    @sport ||= Sport.mlb
  end

end