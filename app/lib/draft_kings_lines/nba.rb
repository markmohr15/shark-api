class DraftKingsLines::Nba < DraftKingsLines::Base

  LEAGUE_ID = 42648
  PROFESSIONAL = true

  def self.sport
    @sport ||= Sport.nba
  end

end