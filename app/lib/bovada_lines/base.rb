class BovadaLines::Base

  def self.raise_api_error err
    Sidekiq.logger.info err
    Bugsnag.notify err
    nil
  end

  def self.agent
    @agent ||= Mechanize.new
  end

  def self.sportsbook
    @sportsbook ||= Sportsbook.find_by_name "Bovada"
  end

  def self.fetch
    @fetch ||= agent.get(url)
  end

  def self.games
    @games ||= JSON.parse(fetch.body)&.first["events"]
  end

  def self.team name
    sport.teams.find_by_bovada_name name
  end

  def self.get_lines
    @nf = []
    games.each do |g|
      game_info = game_info g
      game = Game.Scheduled.where('sport_id = ? and gametime > ? and gametime < ? and home_id = ? and visitor_id = ?', 
                         sport.id, game_info[:time] - 12.hours, game_info[:time] + 12.hours, 
                         team(game_info[:home_name])&.id, team(game_info[:vis_name])&.id).first
      if game.nil?
        @nf << [game_info[:vis_name], game_info[:home_name]]
      else
        create_line game_info, game
      end
    end
    @nf
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.game_info game
    vis_name = game["competitors"].find {|x| x["home"] == false}["name"].split("(")[0].squish
    home_name = game["competitors"].find {|x| x["home"] == true}["name"].split("(")[0].squish
    time = Time.at(game["startTime"] / 1000).to_datetime  
    lines = game["displayGroups"]&.first["markets"]
    vis_spread = vis_rl = home_rl = total = vis_ml = home_ml = nil
    lines.each do |l|
      next if l["outcomes"].empty?
      if l["description"] == "Point Spread"
        vis_spread = l["outcomes"][0]["price"]["handicap"].to_f
        vis_rl = l["outcomes"][0]["price"]["american"]
        vis_rl == "EVEN" ? vis_rl = 100 : vis_rl = vis_rl.to_i
        home_rl = l["outcomes"][1]["price"]["american"]
        home_rl == "EVEN" ? home_rl = 100 : home_rl = home_rl.to_i
      elsif l["description"] == "Total"
        total = l["outcomes"][0]["price"]["handicap"].to_f
      elsif l["description"] == "Moneyline"
        vis_ml = l["outcomes"][0]["price"]["american"].to_i
        vis_ml == "EVEN" ? vis_ml = 100 : vis_ml = vis_ml.to_i
        home_ml = l["outcomes"][1]["price"]["american"].to_i
        home_ml == "EVEN" ? home_ml = 100 : home_ml = home_ml.to_i
      end
    end
    {vis_name: vis_name, home_name: home_name, time: time, vis_spread: vis_spread,
     vis_rl: vis_rl, home_rl: home_rl, total: total, vis_ml: vis_ml, home_ml: home_ml }
  end

  def self.create_line game_info, game
    game.lines.create visitor_spread: game_info[:vis_spread], home_ml: game_info[:home_ml], 
                      home_rl: game_info[:home_rl], visitor_ml: game_info[:vis_ml],
                      visitor_rl: game_info[:vis_rl], total: game_info[:total],
                      game: game, sportsbook: sportsbook
  end

end

