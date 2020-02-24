class SportsdataIoApi::Mlb < SportsdataIoApi::Base
  
  def self.get_current_season
    response = get("/mlb/scores/json/CurrentSeason", {headers: headers})
    if response.success?
      response.parsed_response
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.get_teams
    response = get("/mlb/scores/json/teams", {headers: headers})
    if response.success?
      response.parsed_response.map(&:symbolize_keys).each do |t|
        team = sport.teams.where(sportsdata_id: t[:TeamID], nickname: t[:Name]).first_or_initialize
        league = League.find_by_abbreviation t[:League]
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
    response = get("/mlb/scores/json/stadiums", {headers: headers})
    if response.success?
      response.parsed_response.map(&:symbolize_keys).each do |t|
        stadium = sport.stadiums.where(sportsdata_id: t[:StadiumID]).first_or_create
        stadium.update active: t[:Active], name: t[:Name], city: t[:City],
                       state: t[:State], country: t[:Country], capacity: t[:Capacity],
                       surface: t[:Surface], left_field: t[:LeftField], mid_left_field: t[:MidLeftField],
                       left_center_field: t[:LeftCenterField], mid_left_center_field: t[:MidLeftCenterField],
                       center_field: t[:CenterField], mid_right_center_field: t[:MidRightCenterField],
                       right_center_field: t[:RightCenterField], mid_right_field: t[:MidRightField],
                       right_field: t[:RightField], geo_lat: t[:GeoLat], geo_lng: t[:GeoLong],
                       altitude: t[:Altitude], home_plate_direction: t[:HomePlateDirection], 
                       stadium_type: t[:Type]
      end
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.get_games season
    response = get("/mlb/scores/json/Games/#{season}", {headers: headers})
    if response.success?
      season = sport.seasons.find_by_sportsdata_id season
      response.parsed_response.map(&:symbolize_keys).each do |t|
        game = season.games.where(sportsdata_game_id: t[:GameID], 
                                  visitor: teams.find_by_sportsdata_id(t[:AwayTeamID]), 
                                  home: teams.find_by_sportsdata_id(t[:HomeTeamID]),
                                  stadium: stadiums.find_by_sportsdata_id(t[:StadiumID])).first_or_create        
        game.update(status: t[:Status], when: t[:DateTime], channel: t[:Channel], 
                    spread: t[:PointSpread], total: t[:OverUnder],
                    visitor_score: t[:AwayTeamRuns], home_score: t[:HomeTeamRuns],
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