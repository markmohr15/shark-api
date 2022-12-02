class PinnacleLines::Nba < PinnacleLines::Base

  def self.league_id
    487
  end

  def self.sport
    @sport ||= Sport.nba
  end
  
end