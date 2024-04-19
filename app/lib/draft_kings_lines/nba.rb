class DraftKingsLines::Nba < DraftKingsLines::Base

  def self.league_id
    42648
  end

  def self.sport
    @sport ||= Sport.nba
  end

  def self.professional
    true
  end

end