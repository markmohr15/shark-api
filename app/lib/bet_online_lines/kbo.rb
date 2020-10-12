class BetOnlineLines::Kbo < BetOnlineLines::Base

  def self.url
    "https://www.betonline.ag/sportsbook/baseball/south-korea"
  end

  def self.sport
    sport ||= Sport.find_by_abbreviation "KBO"
  end

  def self.home home_name
    home ||= sport.teams.find_by_nickname home_name.last
    home ||= sport.teams.find_by_nickname home_name[-2..-1].join(" ")
  end
  
  def self.get_lines
    return if base_dates.empty?
    date = self.dates[0][0][0].split(" -")[0].to_date
    if dates.size > 1
      date2 = dates[1][0][0].split(" -")[0].to_date
      t = self.agent.get(url).search('#contestDetailTable').to_html.encode("UTF-8", invalid: :replace).split('date')
      date1_games_count = t[1].scan(/event/).length - t[1].scan(/eventinfo/).length
    end
    counter = 0
    games.each do |g|
      next if g[0][0].blank?
      game_info = self.game_info g
      next if game_info[:vis_lines].empty? || game_info[:home_lines].empty?
      home = self.home game_info[:home_name]
      if dates.size == 1 || counter < date1_games_count
        game = Game.where('sport_id = ? and gametime >= ? and gametime <= ? and home_id = ?', 
                          sport.id, "#{date} #{game_info[:time]}:00 EDT -04:00".to_datetime - 70.minutes + game_info[:time_adjust].hours,
                          "#{date} #{game_info[:time]}:00 EDT -04:00".to_datetime + 70.minutes + game_info[:time_adjust].hours,
                          home&.id).first
      elsif dates.size > 1
        game = Game.where('sport_id = ? and gametime >= ? and gametime <= ? and home_id = ?', 
                         sport.id, "#{date2} #{game_info[:time]}:00 EDT -04:00".to_datetime - 70.minutes + game_info[:time_adjust].hours,
                         "#{date2} #{game_info[:time]}:00 EDT -04:00".to_datetime + 70.minutes + game_info[:time_adjust].hours,
                         home&.id).first
      end
      counter += 1
      next if game.nil?
      total_set = false
      lines = {spread: game.spread, vis_rl: game.visitor_rl, vis_ml: game.visitor_ml,
               home_rl: game.home_rl, home_ml: game.home_ml, total: game.total}
      game_info[:vis_lines][0..2].each do |vl|
        next if vl.include?("Ov") && total_set
        lines.merge!(self.parse_vis_line(vl))
        total_set = true if vl.include? "Ov"
      end
      game_info[:home_lines][0..2].each do |hl|
        lines.merge!(self.parse_home_line(hl))
      end
      game.update spread: lines[:spread], home_ml: lines[:home_ml], 
                  home_rl: lines[:home_rl], visitor_ml: lines[:vis_ml],
                  visitor_rl: lines[:vis_rl], total: lines[:total],
                  visitor_rot: game_info[:home_rot].to_i - 1, 
                  home_rot: game_info[:home_rot]
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

end