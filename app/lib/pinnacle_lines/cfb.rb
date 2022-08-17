class PinnacleLines::Cfb < PinnacleLines::Base

  def self.league_id
    880
  end

  def self.sport
    @sport ||= Sport.cfb
  end
  
end