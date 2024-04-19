class DraftKingsLines::Mlb < DraftKingsLines::Base

  def self.league_id
    84240
  end

  def self.sport
    @sport ||= Sport.mlb
  end

  def self.professional
    true
  end

end