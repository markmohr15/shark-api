class DraftKingsLines::Nhl < DraftKingsLines::Base

  def self.league_id
    42133
  end

  def self.sport
    @sport ||= Sport.nhl
  end

  def self.professional
    true
  end

end