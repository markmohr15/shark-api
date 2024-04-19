class DraftKingsLines::Cbb < DraftKingsLines::Base

  def self.league_id
    92483
  end

  def self.sport
    @sport ||= Sport.cbb
  end

  def self.professional
    false
  end

end