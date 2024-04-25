class DraftKingsLines::Nhl < DraftKingsLines::Base

  LEAGUE_ID = 42133
  PROFESSIONAL = true

  def self.sport
    @sport ||= Sport.nhl
  end

end