class SportsdataIoApi::Nhl < SportsdataIoApi::Base
  
  def self.get_current_season
    response = get("/nhl/scores/json/CurrentSeason", {headers: headers})
    if response.success?
      response.parsed_response
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.get_teams
    response = get("/nhl/scores/json/teams", {headers: headers})
    if response.success?
      response.parsed_response.map(&:symbolize_keys).each do |t|
        sport = Sport.nhl
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

  def self.get_stadiums
    response = get("/nhl/scores/json/stadiums", {headers: headers})
    if response.success?
      response.parsed_response.map(&:symbolize_keys).each do |t|
        stadium = sport.stadiums.where(sportsdata_id: t[:StadiumID]).first_or_create
        stadium.update active: t[:Active], name: t[:Name], city: t[:City],
                       state: t[:State], country: t[:Country], capacity: t[:Capacity],
                       geo_lat: t[:GeoLat], geo_lng: t[:GeoLong]
      end
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.get_games season
    response = get("/nhl/scores/json/Games/#{season}", {headers: headers})
    if response.success?
      season = sport.seasons.find_by_sportsdata_id season
      response.parsed_response.map(&:symbolize_keys).each do |t|
        game = season.games.where(sportsdata_game_id: t[:GameID], 
                                  visitor: teams.find_by_sportsdata_id(t[:AwayTeamID]), 
                                  home: teams.find_by_sportsdata_id(t[:HomeTeamID]),
                                  stadium: stadiums.find_by_sportsdata_id(t[:StadiumID])).first_or_create        
        game.update(status: t[:Status], when: t[:DateTime], channel: t[:Channel],
                    spread: t[:PointSpread], total: t[:OverUnder],
                    visitor_score: t[:AwayTeamScore], home_score: t[:HomeTeamScore],
                    visitor_ml: t[:AwayTeamMoneyLine], home_ml: t[:HomeTeamMoneyLine],
                    visitor_rl: t[:PointSpreadAwayTeamMoneyLine], home_rl: t[:PointSpreadHomeTeamMoneyLine],
                    visitor_rot: t[:AwayRotationNumber], home_rot: t[:HomeRotationNumber])
      end
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end


end