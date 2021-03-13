class BovadaLines::Mlb < BovadaLines::Base

  def self.url
    @url ||= "https://www.bovada.lv/services/sports/event/coupon/events/A/description/baseball/mlb-exhibition?marketFilterId=def&preMatchOnly=true&lang=en"
  end

  def self.sport
    @sport ||= Sport.mlb
  end

end

