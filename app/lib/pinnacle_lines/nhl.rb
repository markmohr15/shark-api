class PinnacleLines::Nhl < PinnacleLines::Base

  def self.league_id
    1456
  end

  def self.sport
    @sport ||= Sport.nhl
  end
  
end