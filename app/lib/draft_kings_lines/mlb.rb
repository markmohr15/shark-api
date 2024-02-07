class DraftKingsLines::Mlb < DraftKingsLines::Base

  def self.league_id
    92483 #need this
  end

  def self.sport
    @sport ||= Sport.mlb
  end

  def self.professional
    true
  end

end