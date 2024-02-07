class DraftKingsLines::Base

  def self.raise_api_error err
    Sidekiq.logger.info err
    Bugsnag.notify err
    nil
  end

  def self.sportsbook
    @sportsbook ||= Sportsbook.find_by_name "Draft Kings"
  end

  def self.fetch
    @fetch ||= HTTParty.get "https://sportsbook.draftkings.com/sites/US-SB/api/v5/eventgroups/#{league_id}?format=json"
  end

  def self.games
    @games ||= fetch["eventGroup"]["offerCategories"][0]["offerSubcategoryDescriptors"][0]["offerSubcategory"]["offers"]
  end

  def self.events
    @events ||= fetch["eventGroup"]["events"]
  end

  def self.team name
    sport.tags.where("lower(tags.name) = ?", name.downcase)&.first&.team
  end

  def self.get_lines
    @events = @fetch = @games = nil
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
    event = events.find {|e| e["eventId"] == game[0]["eventId"]}
    vis_name =  professional ? event["teamName1"].split(" ")[1..-1].join(" ") : event["teamName1"]
    home_name = professional ? event["teamName2"].split(" ")[1..-1].join(" ") : event["teamName2"]
    time = event["startDate"].to_datetime  
    vis_spread = vis_rl = home_rl = total = vis_ml = home_ml = over_juice = under_juice = nil
    game.each do |l|
      next if l["outcomes"].empty?
      if ["Spread", "Puck Line", "Runline"].include? l["label"]
        vis_spread = l["outcomes"][0]["line"].to_f
        vis_rl = l["outcomes"][0]["oddsAmerican"]
        home_rl = l["outcomes"][1]["oddsAmerican"]
      elsif l["label"] == "Total"
        total = l["outcomes"][0]["line"].to_f
        over_juice = l["outcomes"].find {|x| x["label"] == "Over"}["oddsAmerican"]
        under_juice = l["outcomes"].find {|x| x["label"] == "Under"}["oddsAmerican"]
      elsif l["label"] == "Moneyline" 
        vis_ml = l["outcomes"][0]["oddsAmerican"]
        home_ml = l["outcomes"][1]["oddsAmerican"]
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

