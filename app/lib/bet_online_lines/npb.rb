class BetOnlineLines::Npb < BetOnlineLines::Base
  
  URL = "https://www.betonline.ag/sportsbook/baseball/japan"

  def self.sport
    @sport ||= Sport.npb
  end

  def self.team name
    tag = sport.tags.find_by_name(name.last) || sport.tags.find_by_name(name[-2..-1].join(" "))
    tag&.team
  end
  
  def self.get_lines
    @url = @fetch = @base_dates = @base_games = @dates = @games = nil

    return if base_dates.empty?
    date = dates[0][0][0].split(" -")[0].to_date
    if dates.size > 1
      date2 = dates[1][0][0].split(" -")[0].to_date
      t = agent.get(url).search('#contestDetailTable').to_html.encode("UTF-8", invalid: :replace).split('date')
      date1_games_count = t[1].scan(/event/).length - t[1].scan(/eventinfo/).length
    end
    counter = 0
    games.each do |g|
      next if g[0][0].blank?
      game_info = game_info g
      next if game_info[:vis_lines].empty? || game_info[:home_lines].empty?
      if dates.size == 1 || counter < date1_games_count
        game = Game.Scheduled.where('sport_id = ? and gametime >= ? and gametime <= ? and home_id = ?', 
                          sport.id, "#{date} #{game_info[:time]}:00 EDT -04:00".to_datetime - 70.minutes + game_info[:time_adjust].hours,
                          "#{date} #{game_info[:time]}:00 EDT -04:00".to_datetime + 70.minutes + game_info[:time_adjust].hours,
                          team(game_info[:home_name])&.id).first
      elsif dates.size > 1
        game = Game.Scheduled.where('sport_id = ? and gametime >= ? and gametime <= ? and home_id = ?', 
                         sport.id, "#{date2} #{game_info[:time]}:00 EDT -04:00".to_datetime - 70.minutes + game_info[:time_adjust].hours,
                         "#{date2} #{game_info[:time]}:00 EDT -04:00".to_datetime + 70.minutes + game_info[:time_adjust].hours,
                         team(game_info[:home_name])&.id).first
      end
      counter += 1
      next if game.nil?
      create_line game_info, game
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

end