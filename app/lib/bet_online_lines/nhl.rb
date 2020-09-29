class BetOnlineLines::Nhl < BetOnlineLines::Base
  
  def self.get_lines
    sport = Sport.find_by_abbreviation 'NHL'
    agent = Mechanize.new
    base_dates = agent.get("https://www.betonline.ag/sportsbook/hockey/nhl").search(".date")
    return if base_dates.empty?
    base_games = agent.get("https://www.betonline.ag/sportsbook/hockey/nhl").search(".event")
    dates = base_dates.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
    games = base_games.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
    date = dates[0][0][0].split(" -")[0].to_date
    if dates.size > 1
      date2 = dates[1][0][0].split(" -")[0].to_date
    end

    games.each do |g|
      next if g[0][0].blank?
      top = g[0][0].gsub("\n", "").split(" ")
      bottom = g[1][0].gsub("\n", "").split(" ")
      time = top[0]
      time_adjust = top[1][0..1] == "PM" ? 12 : 0
      vis_rot = top[1][2..4]
      if top.include?('Wings') || top.include?("Leafs") || top.include?("Jackets") || top.include?("Knights")
        visitor = sport.teams.where('nickname = ?', top[2] + " " + top[3]).first
      else
        visitor = sport.teams.where('(nickname || name) ilike ?', "%#{top[2]}%").first
      end
      if bottom.include?('Wings') || bottom.include?("Leafs") || bottom.include?("Jackets") || bottom.include?("Knights")
        home = sport.teams.where('nickname = ?', bottom[1] + " " + bottom[2]).first
      else
          home = sport.teams.where('(nickname || name) ilike ?', "%#{bottom[1]}%").first
      end
      game = Game.where('sport_id = ? and gametime = ? and visitor_id = ? and home_id = ?', 
                         sport.id, "#{date} #{time}:00 EDT -04:00".to_datetime + time_adjust.hours, 
                         visitor.id, home.id).first
            
      if game.nil? && dates.size < 2
        next
      elsif game.nil?
        game = Game.where('sport_id = ? and gametime = ? and visitor_id = ? and home_id = ?', 
                         sport.id, "#{date2} #{time}:00 EDT -04:00".to_datetime + time_adjust.hours, 
                         visitor.id, home.id).first
      end
      next if game.nil?

      spread = game.spread
      vis_rl = game.visitor_rl
      vis_ml = game.visitor_ml
      home_rl = game.home_rl
      home_ml = game.home_ml
      total = game.total

      vis_lines = top.select {|x| x.length > 2 && (x.include?("Ov") || x.include?("Un") || x.include?("+") || x.include?("-") || x.include?("½"))}
      home_lines = bottom.select {|x| x.length > 2 && (x.include?("Ov") || x.include?("Un") || x.include?("+") || x.include?("-") || x.include?("½"))}

      next if vis_lines.empty? || home_lines.empty?
      if vis_lines[0].include?("½")
        runlines = vis_lines[0].split("½")
        spread = runlines[0].to_f 
        half = spread > 0 ? 0.5 : -0.5
        spread = (spread + half) * -1
        vis_rl = runlines[1].gsub("o", "").to_i
      elsif vis_lines[0].exclude?("Ov") && vis_lines[0].exclude?("Un")
        spread = nil
        vis_rl = nil
        vis_ml = vis_lines[0].gsub("o", "").to_i
      else
        total = vis_lines[0].gsub("Ov", "").split(/[-,+]/)[0]
      end
      if vis_lines[1].present?
        if vis_lines[1].exclude?("Ov") && vis_lines[1].exclude?("Un")
          vis_ml = vis_lines[1].gsub("o", "").to_i
          total = vis_lines[2].gsub("Ov", "").split(/[-,+]/)[0] if vis_lines[2].present?
        else
          total = vis_lines[1].gsub("Ov", "").split(/[-,+]/)[0]
        end

        half = total.include?("½") ? 0.5 : 0
        total = total.to_f + half      
      end
      if home_lines[0].include?("½")
        runlines = home_lines[0].split("½")
        home_rl = runlines[1].gsub("o", "").to_i
      elsif home_lines[0].exclude?("Ov") && home_lines[0].exclude?("Un")
        home_rl = nil
        home_ml = home_lines[0].gsub("o", "").to_i
      end
      if home_lines[1].present? && home_lines[1].exclude?("Ov") && home_lines[1].exclude?("Un")
        home_ml = home_lines[1].gsub("o", "").to_i
      end
      game.update spread: spread, home_ml: home_ml, home_rl: home_rl, 
                  visitor_ml: vis_ml, visitor_rl: vis_rl, total: total,
                  visitor_rot: vis_rot, home_rot: vis_rot.to_i + 1
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

end