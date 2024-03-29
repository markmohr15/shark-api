class MyBookieLines::Base

  def self.raise_api_error err
    Sidekiq.logger.info err
    Bugsnag.notify err
    nil
  end

  def self.agent
    @agent ||= Mechanize.new
  end

  def self.sportsbook
    @sportsbook ||= Sportsbook.find_by_name "MyBookie"
  end

  def self.fetch
    @fetch ||= agent.get(url)
  end

  def self.games
    @games ||= fetch.search(".game-line")
  end

  def self.team name
    sport.tags.where("lower(tags.name) = ?", name.downcase)&.first&.team
  end

  def self.get_lines
    @url = @fetch = @games = nil
    @nf = []
    @found = []

    games.each do |g|
      game_info = game_info g
      next if game_info[:next]
      game = sport.games.Scheduled
                        .where.not(id: @found)
                        .where('gametime > ? and gametime < ? and home_id = ? and visitor_id = ?', 
                          game_info[:time] - 90.minutes, game_info[:time] + 90.minutes,
                          team(game_info[:home_name])&.id, 
                          team(game_info[:vis_name])&.id).first
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
    date = game.search('.game-line__time__date')&.children[0]&.text.gsub("-", "")&.squish
    time = game.search('.game-line__time__date__hour')&.children[0]&.text&.squish
    vis_name = game.search(".game-line__visitor-team")&.children[1]&.children&.children&.text&.squish
    return {next: true} if vis_name.nil?
    vis_spread = game.search(".game-line__visitor-line")&.children[3]&.children[0]&.text&.squish
    vis_rl = game.search(".game-line__visitor-line")&.children[3]&.children[2]&.text&.squish
    vis_ml = game.search(".game-line__visitor-line")&.children[9]&.children[0]&.text&.squish
    total = game.search(".game-line__visitor-line")&.children[15]&.children[0]&.text.to_s.gsub("O", "")&.squish
    over_juice = game.search(".game-line__visitor-line")&.children[15]&.children[2]&.text
    home_name = game.search(".game-line__home-team")&.children[1]&.children&.children&.text&.squish
    home_rl = game.search(".game-line__home-line")&.children[3]&.children[2]&.text&.squish
    home_ml = game.search(".game-line__home-line")&.children[9]&.children[0]&.text&.squish
    under_juice = game.search(".game-line__home-line")&.children[15]&.children[2]&.text
    
    {time: Time.zone.parse("#{DateTime.now.year}/#{date} #{time}"), vis_name: vis_name, 
     home_name: home_name, vis_spread: parse_spread(vis_spread), vis_rl: parse_juice(vis_rl), vis_ml: parse_juice(vis_ml), 
     total: parse_spread(total), over_juice: parse_juice(over_juice), under_juice: parse_juice(under_juice), 
     home_rl: parse_juice(home_rl), home_ml: parse_juice(home_ml)}
  end

  def self.parse_spread spread
    if spread.to_s.include? "&frac12"
      spread = spread.gsub("&frac12", "").to_f 
      spread += spread > 0 ? 0.5 : -0.5
    elsif spread == "-"
      nil
    else
      spread.to_f
    end
  end

  def self.parse_juice juice
    return juice if juice.exclude?(".")
    juice = juice.to_f
    if juice < 2
      (-100 / (juice - 1)).round(1).to_i
    else
      ((juice - 1) * 100).round(1).to_i
    end
  end


  def self.create_line game_info, game
    game.lines.create visitor_spread: game_info[:vis_spread], home_ml: game_info[:home_ml], 
                      home_rl: game_info[:home_rl], visitor_ml: game_info[:vis_ml],
                      visitor_rl: game_info[:vis_rl], total: game_info[:total],
                      over_odds: game_info[:over_juice], under_odds: game_info[:under_juice],
                      game: game, sportsbook: sportsbook
  end

end