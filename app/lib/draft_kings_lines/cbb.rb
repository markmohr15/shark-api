class DraftKingsLines::Cbb < DraftKingsLines::Base

  LEAGUE_ID = 92483
  PROFESSIONAL = false
  
  def self.sport
    @sport ||= Sport.cbb
  end

end