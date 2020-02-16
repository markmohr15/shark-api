class SportsdataIoApi::Nba < SportsdataIoApi::Base
  
  def self.current_season
    response = get("/nba/scores/json/CurrentSeason", {headers: headers})
    if response.success?
      response.parsed_response
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.teams
    response = get("/nba/scores/json/teams", {headers: headers})
    if response.success?
      response.parsed_response.map(&:symbolize_keys).each do |t|
        sport = Sport.find_by_abbreviation "NBA"
        team = Team.where(sportsdata_id: t[:TeamID], nickname: t[:Name], sport: sport).first_or_initialize
        league = sport.leagues.where("name ilike ?", "%#{t[:Conference]}%").first
        div = league.divisions.where("name ilike ?", "%#{t[:Division]}%").first
        team.update(name: t[:City], league: league, division: div, short_display_name: t[:Key])
      end
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end


end