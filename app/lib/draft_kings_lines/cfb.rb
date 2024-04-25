class DraftKingsLines::Cfb < DraftKingsLines::Base

  LEAGUE_ID = 92483 #need to update this
  PROFESSIONAL = false

  def self.sport
    @sport ||= Sport.cfb
  end

end