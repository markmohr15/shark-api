class PinnacleLines::Nfl < PinnacleLines::Base

  def self.league_id
    889
  end

  def self.sport
    @sport ||= Sport.nfl
  end
  
end