class PinnacleLines::Cbb < PinnacleLines::Base

  def self.league_id
    493
  end

  def self.sport
    @sport ||= Sport.cbb
  end
  
end