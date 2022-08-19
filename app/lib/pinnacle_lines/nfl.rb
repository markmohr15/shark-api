class PinnacleLines::Nfl < PinnacleLines::Base

  def self.league_id
    889
  end

  def self.preseason_league_id
    4347
  end

  def self.sport
    @sport ||= Sport.nfl
  end
  
end