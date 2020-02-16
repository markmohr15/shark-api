class SportsdataIoApi::Cfb < SportsdataIoApi::Base
  
  def self.current_season
    response = get("/cfb/scores/json/CurrentSeason", {headers: headers})
    if response.success?
      response.parsed_response
    else
      raise_api_error response.response
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.teams
    response = get("/cfb/scores/json/teams", {headers: headers})
    if response.success?
      response.parsed_response.map(&:symbolize_keys).each do |t|
        sport = Sport.find_by_abbreviation "CFB"
        team = Team.where(sportsdata_id: t[:TeamID], name: t[:School], sport: sport).first_or_initialize
        div_subdiv = t[:Conference].to_s.split(" - ")
        if div_subdiv[0].present?
          div = sport.divisions.where("divisions.name ilike ? or divisions.abbreviation ilike ?", "%#{div_subdiv[0].strip}%", "%#{div_subdiv[0].strip}%")&.first
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


end