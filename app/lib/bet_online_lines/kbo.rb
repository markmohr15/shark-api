class BetOnlineLines::Kbo < BetOnlineLines::Base
  
  def self.get_lines
    sport = Sport.find_by_abbreviation 'KBO'
    agent = Mechanize.new
    base_dates = agent.get("https://www.betonline.ag/sportsbook/baseball/south-korea").search(".date")
    base_games = agent.get("https://www.betonline.ag/sportsbook/baseball/south-korea").search(".event")
    dates = base_dates.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
    games = base_games.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
    if dates.size == 1
      date = dates[0][0][0].split(" -")[0].to_date
    else
      #figure it out for 2
    end
    games.each do |g|
      next if g[0][0].blank?
      top = g[0][0].gsub("\n", "").split(" ")
      bottom = g[1][0].gsub("\n", "").split(" ")
      visitor = sport.teams.find_by_nickname top[2]
      home = sport.teams.find_by_nickname bottom[1]
      game = Game.where('sport_id = ? and gametime >= ? and
                         gametime <= ? and visitor_id = ? and home_id = ?', 
                         sport.id, date.to_date.beginning_of_day, date.to_date.end_of_day, 
                         visitor.id, home.id).first
      next if game.nil?
      vis_lines = visitor.nickname == "Wiz" ? top[4..-1] : top[3..-1]
      home_lines = home.nickname == "Wiz" ? bottom[3..-1] : bottom[2..-1]
      if vis_lines[0].include?("½")
        runlines = vis_lines[0].split("½")
        spread = runlines[0].to_f 
        half = spread > 0 ? 0.5 : -0.5
        spread = (spread + half) * -1
        vis_rl = runlines[1].gsub("o", "").to_i
      else
        spread = nil
        vis_rl = nil
        vis_ml = vis_lines[0].gsub("o", "").to_i
      end
      if spread.present?
        vis_ml = vis_lines[1].gsub("o", "").to_i
        total = vis_lines[2].gsub("Ov", "").split(/[-,+]/)[0]
      else
        total = vis_lines[1].gsub("Ov", "").split(/[-,+]/)[0]
      end
      half = total.include?("½") ? 0.5 : 0
      total = total.to_f + half      
      
      if home_lines[0].include?("½")
        runlines = home_lines[0].split("½")
        home_rl = runlines[1].gsub("o", "").to_i
      else
        home_rl = nil
        home_ml = home_lines[0].gsub("o", "").to_i
      end
      if spread.present?
        home_ml = home_lines[1].gsub("o", "").to_i
      end
      game.update spread: spread, home_ml: home_ml, home_rl: home_rl, 
                  visitor_ml: vis_ml, visitor_rl: vis_rl, total: total
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

end