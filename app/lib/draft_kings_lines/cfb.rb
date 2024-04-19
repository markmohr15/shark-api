class DraftKingsLines::Cfb < DraftKingsLines::Base

  def self.league_id
    92483 #need this
  end

  def self.sport
    @sport ||= Sport.cfb
  end

  def self.professional
    false
  end

end