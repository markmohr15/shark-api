class DraftKingsLines::Mlb < DraftKingsLines::Base

  LEAGUE_ID = 84240
  PROFESSIONAL = true

  def self.sport
    @sport ||= Sport.mlb
  end

end