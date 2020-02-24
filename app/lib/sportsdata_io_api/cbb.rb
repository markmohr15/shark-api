class SportsdataIoApi::Cbb < SportsdataIoApi::Base
  
  def self.get_current_season
    response = get("/cbb/scores/json/CurrentSeason", {headers: headers})
    if response.success?
      response.parsed_response
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.get_teams
    response = get("/cbb/scores/json/teams", {headers: headers})
    if response.success?
      response.parsed_response.map(&:symbolize_keys).each do |t|
        sport = Sport.cbb
        team = Team.where(sportsdata_id: t[:TeamID], name: t[:School], sport: sport).first_or_initialize
        div_subdiv = t[:Conference].to_s.split(" - ")
        if div_subdiv[0].present?
          div = sport.divisions.where("divisions.name like ? or divisions.abbreviation ilike ?", "%#{div_subdiv[0].strip}%", "%#{div_subdiv[0].strip}%")&.first
          if div_subdiv.size > 1 && div.present?
            subdiv = div.subdivisions.where("subdivisions.name ilike ?", "%#{div_subdiv[1].strip}%")&.first
          else
            subdiv = nil
          end
        else
          div = nil
        end
        team.update(nickname: t[:Name], league: div&.league, division: div, subdivision: subdiv, short_display_name: t[:ShortDisplayName])
      end
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.get_stadiums
    response = get("/cbb/scores/json/stadiums", {headers: headers})
    if response.success?
      response.parsed_response.map(&:symbolize_keys).each do |t|
        stadium = sport.stadiums.where(sportsdata_id: t[:StadiumID]).first_or_create
        stadium.update active: t[:Active], name: t[:Name], city: t[:City],
                       state: t[:State], country: t[:Country], capacity: t[:Capacity]
      end
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.get_games season
    response = get("/cbb/scores/json/Games/#{season}", {headers: headers})
    if response.success?
      season = sport.seasons.find_by_sportsdata_id season
      response.parsed_response.map(&:symbolize_keys).each do |t|
        next if t[:Status] == "Canceled"
        next if t[:Stadium].blank?
        game = season.games.where(sportsdata_game_id: t[:GameID], 
                                  visitor: teams.find_by_sportsdata_id(t[:AwayTeamID]), 
                                  home: teams.find_by_sportsdata_id(t[:HomeTeamID]),
                                  stadium: stadiums.find_by_sportsdata_id(t[:Stadium]["StadiumID"])).first_or_create        
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