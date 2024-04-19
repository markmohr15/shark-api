class DraftKingsLines::Nfl < DraftKingsLines::Base

  def self.league_id
    88808
  end

  def self.sport
    @sport ||= Sport.nfl
  end

  def self.professional
    true
  end
  
end