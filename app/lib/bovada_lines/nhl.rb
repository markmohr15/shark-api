class BovadaLines::Nhl < BovadaLines::Base

  def self.url
    @url ||= "https://www.bovada.lv/services/sports/event/coupon/events/A/description/hockey?marketFilterId=def&preMatchOnly=true&eventsLimit=50&lang=en"
  end

  def self.sport
    @sport ||= Sport.find_by_abbreviation "NHL"
  end

end