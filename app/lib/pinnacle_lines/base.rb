require 'open-uri'
require "net/http"

class PinnacleLines::Base

  def self.raise_api_error err
    Sidekiq.logger.info err
    Bugsnag.notify err
    nil
  end

  def self.found
    @found ||= []
  end

  def self.nf
    @nf ||= []
  end

  def self.sportsbook
    @sportsbook ||= Sportsbook.find_by_name "Pinnacle"
  end

  def self.fetch_games league_id
    url = "https://guest.api.arcadia.pinnacle.com/0.1/leagues/#{league_id}/matchups"
    headers = {'X-API-Key': 'CmX2KcMrXuFmNg6YFbmTxE0y9CIrOi0R'}
    response = HTTParty.get(url, headers: headers)
    response.body
  end

  def self.fetch_lines league_id
    url = "https://guest.api.arcadia.pinnacle.com/0.1/leagues/#{league_id}/markets/straight"
    headers = {'X-API-Key': 'CmX2KcMrXuFmNg6YFbmTxE0y9CIrOi0R'}
    response = HTTParty.get(url, headers: headers)
    response.body
  end

  def self.games
    @games ||= JSON.parse(fetch_games(league_id))
  end

  def self.lines
    @lines ||= JSON.parse(fetch_lines(league_id))
  end

  def self.preseason_games
    @preseason_games = [] unless defined?(preseason_league_id)
    @preseason_games ||= JSON.parse(fetch_games(preseason_league_id))
  end

  def self.preseason_lines
    @preseason_lines ||= JSON.parse(fetch_lines(preseason_league_id))
  end

  def self.team name
    sport.tags.where("lower(tags.name) = ?", name.downcase)&.first&.team
  end

  def self.get_lines
    @games = @lines = @preseason_games = @preseason_lines = nil
    @nf = []
    @found = []

    games.each do |g|
      process_game g
    end

    preseason_games.each do |g|
      process_game g, true
    end

    nf
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.process_game game, preseason = false
    return if game["participants"].size != 2 || game["units"] != "Regular" || game["parentId"].present? || game["special"].present?
    game_info = game_info game, preseason
    game = sport.games.Scheduled.where.not(id: @found)  
                                .where('gametime > ? and gametime < ? and home_id = ? and visitor_id = ?', 
                                       game_info[:time] - 90.minutes, game_info[:time] + 90.minutes, 
                                       team(game_info[:home_name])&.id, team(game_info[:vis_name])&.id).first
    if game.nil?
      nf << [game_info[:vis_name], game_info[:home_name]]
    else
      create_line game_info, game
      found << game.id
    end
  end

  def self.linepicker preseason = false
    preseason ? preseason_lines : lines
  end

  def self.game_info game, preseason = false
    pin_game_id = game["id"]
    vis_name = game["participants"].find {|x| x["alignment"] == "away"}["name"].split("(")[0].squish
    home_name = game["participants"].find {|x| x["alignment"] == "home"}["name"].split("(")[0].squish
    time = "#{game["startTime"]} GMT".to_datetime
    correct_lines = linepicker(preseason)
    spread_line = correct_lines.find {|l| l["matchupId"] == pin_game_id && l["key"][0..2] == "s;0" && l["isAlternate"] == false && l["type"] == "spread" }
    ml_line = correct_lines.find {|l| l["matchupId"] == pin_game_id && l["key"][0..2] == "s;0" && l["isAlternate"] == false && l["type"] == "moneyline"}
    total_line = correct_lines.find {|l| l["matchupId"] == pin_game_id && l["key"][0..2] == "s;0" && l["isAlternate"] == false && l["type"] == "total"}
    vis_spread = vis_rl = home_rl = total = vis_ml = home_ml = over_juice = under_juice = nil
    if spread_line
      vis = spread_line["prices"].find{|sl| sl["designation"] == "away"}
      home = spread_line["prices"].find{|sl| sl["designation"] == "home"}
      vis_spread = vis["points"].to_f
      vis_rl = vis["price"]
      home_rl = home["price"]
    end
    if total_line
      total = total_line["prices"][0]["points"]
      over_juice = total_line["prices"].find {|x| x["designation"] == "over"}["price"]
      under_juice = total_line["prices"].find {|x| x["designation"] == "under"}["price"]
    end
    if ml_line
      vis_ml = ml_line["prices"].find {|x| x["designation"] == "away"}["price"]
      home_ml = ml_line["prices"].find {|x| x["designation"] == "home"}["price"]
    end
    {vis_name: vis_name, home_name: home_name, time: time, vis_spread: vis_spread,
     vis_rl: vis_rl, home_rl: home_rl, total: total, vis_ml: vis_ml, home_ml: home_ml,
     over_juice: over_juice, under_juice: under_juice }
  end

  def self.create_line game_info, game
    game.lines.create visitor_spread: game_info[:vis_spread], home_ml: game_info[:home_ml], 
                      home_rl: game_info[:home_rl], visitor_ml: game_info[:vis_ml],
                      visitor_rl: game_info[:vis_rl], total: game_info[:total],
                      over_odds: game_info[:over_juice], under_odds: game_info[:under_juice],
                      game: game, sportsbook: sportsbook
  end

end

