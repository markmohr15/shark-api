class CaesarsLines::Base

  def self.raise_api_error err
    Sidekiq.logger.info err
    Bugsnag.notify err
    nil
  end

  def self.headers
    { "x-platform" => "cordova-desktop",
      "user-agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
    }
  end

  def self.sportsbook
    @sportsbook ||= Sportsbook.find_by_name "Caesars"
  end

  def self.fetch
    if Rails.env.development?
      @fetch ||= HTTParty.get(url, headers: headers)
    else
      @fetch ||= HTTParty.get(proxy_url)
    end
  end

  def self.proxy_url
    "https://6350-72-198-216-227.ngrok-free.app/caesars/#{sport.abbreviation.downcase}"
  end

  def self.games
    @games ||= fetch["competitions"][0]["events"].select {|x| !x["started"]}
  end

  def self.team name
    sport.tags.where("lower(tags.name) = ?", name.downcase)&.first&.team
  end

  def self.get_lines
    @fetch = @games = nil
    @nf = []
    @found = []

    games.each do |g|
      game_info = game_info g
      game = sport.games.Scheduled.where.not(id: @found)
                                  .where('gametime > ? and gametime < ? and home_id = ? and visitor_id = ?', 
                         game_info[:time] - 90.minutes, game_info[:time] + 90.minutes, 
                         team(game_info[:home_name])&.id, team(game_info[:vis_name])&.id).first
      if game.nil?
        @nf << [game_info[:vis_name], game_info[:home_name]]
      else
        create_line game_info, game
        @found << game.id
      end
    end
    @nf
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.game_info game
    vis_name =  game['markets'][0]['selections'][0]['teamData']['teamName']
    home_name = game['markets'][0]['selections'][1]['teamData']['teamName']
    time = game["startTime"].to_datetime  
    vis_spread = vis_rl = home_rl = total = vis_ml = home_ml = over_juice = under_juice = nil
    game['markets'].each do |l|
      next if l['selections'].empty?
      if ["Spread", "Puck Line", "Run Line"].include? l["displayName"]
        vis_spread = l["line"].to_f * -1
        vis_rl = l["selections"][0]["price"]["a"]
        home_rl = l["selections"][1]["price"]["a"]
      elsif l['displayName'].include? "Total"
        total = l["line"].to_f
        over_juice = l["selections"][0]["price"]["a"]
        under_juice = l["selections"][1]["price"]["a"]
      elsif l["displayName"] == "Money Line" 
        vis_ml = l["selections"][0]["price"]["a"]
        home_ml = l["selections"][1]["price"]["a"]
      end
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
