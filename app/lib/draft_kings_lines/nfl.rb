class DraftKingsLines::Nfl < DraftKingsLines::Base

  LEAGUE_ID = 88808
  PROFESSIONAL = true

  def self.sport
    @sport ||= Sport.nfl
  end
  
end