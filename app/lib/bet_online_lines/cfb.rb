class BetOnlineLines::Cfb < BetOnlineLines::Base

  def self.url
    "https://www.betonline.ag/sportsbook/football/ncaa"
  end

  def self.sport
    sport ||= Sport.find_by_abbreviation "CFB"
  end

  def self.home home_name
    home ||= sport.teams.find_by_name home_name.join(" ")
  end
  
  def self.get_lines
    return if self.base_dates.empty?
    date = self.dates[0][0][0].split(" -")[0].to_date
    date2 = dates[dates.size - 1][0][0].split(" -")[0].to_date
    games.each do |g|
      next if g[0][0].blank?
      game_info = self.game_info g
      next if game_info[:vis_lines].empty? || game_info[:home_lines].empty?
      home = self.home game_info[:home_name]
      game = Game.where('sport_id = ? and gametime > ? and gametime < ? and home_id = ?', 
                         sport.id, date.to_datetime, date2.to_datetime.end_of_day + 6.hours, 
                         home&.id).first
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