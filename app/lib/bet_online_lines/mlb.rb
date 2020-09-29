class BetOnlineLines::Mlb < BetOnlineLines::Base
  
  def self.get_lines
    sport = Sport.find_by_abbreviation 'MLB'
    agent = Mechanize.new
    base_dates = agent.get("https://www.betonline.ag/sportsbook/baseball/mlb").search(".date")
    return if base_dates.empty?
    base_games = agent.get("https://www.betonline.ag/sportsbook/baseball/mlb").search(".event")
    dates = base_dates.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
    games = base_games.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
    date = dates[0][0][0].split(" -")[0].to_date
    if dates.size > 1
      date2 = dates[1][0][0].split(" -")[0].to_date
      t = agent.get("https://www.betonline.ag/sportsbook/baseball/mlb").search('#contestDetailTable').to_html.encode("UTF-8", invalid: :replace).split('date')
      date1_games_count = t[1].scan(/event/).length - t[1].scan(/eventinfo/).length
    end
    counter = 0
    games.each do |g|
      next if g[0][0].blank?
      top = g[0][0].gsub("\n", "").split(" ")
      bottom = g[1][0].gsub("\n", "").split(" ")
      time = top[0]
      time_adjust = top[1][0..1] == "PM" && top[0][0..1] != "12" ? 12 : 0
      home_rot = bottom[0].delete("^0-9")
      home_name = [bottom[0][home_rot.size..-1]]
      vis_lines = []
      home_lines = []
      top[2..-1].each do |x|
        next if x.length < 3
        if x[0] == "-" || x[0] == "+" || x[0..1] == "pk" || x[0..1] == "Ov" || x[0..1] == "Un"
          vis_lines << x
        end
      end

      bottom[1..-1].each do |x|
        next if x.length < 3 || x == "Game"
        if x[0] == "-" || x[0] == "+" || x[0..1] == "pk" || x[0..1] == "Ov" || x[0..1] == "Un"
          home_lines << x
        else
          home_name << x
        end
      end
      next if vis_lines.empty? || home_lines.empty?
      home = sport.teams.find_by_nickname home_name.last
      home = sport.teams.find_by_nickname home_name[-2..-1].join(" ") if home.nil?
      if dates.size == 1 || counter < date1_games_count
        game = Game.where('sport_id = ? and gametime >= ? and gametime <= ? and home_id = ?', 
                          sport.id, "#{date} #{time}:00 EDT -04:00".to_datetime - 70.minutes + time_adjust.hours,
                          "#{date} #{time}:00 EDT -04:00".to_datetime + 70.minutes + time_adjust.hours,
                          home&.id).first
            
      elsif dates.size > 1
        game = Game.where('sport_id = ? and gametime >= ? and gametime <= ? and home_id = ?', 
                         sport.id, "#{date2} #{time}:00 EDT -04:00".to_datetime - 70.minutes + time_adjust.hours,
                         "#{date2} #{time}:00 EDT -04:00".to_datetime + 70.minutes + time_adjust.hours,
                         home&.id).first
      end
      counter += 1
      next if game.nil?

      spread = game.spread
      vis_rl = game.visitor_rl
      vis_ml = game.visitor_ml
      home_rl = game.home_rl
      home_ml = game.home_ml
      total = game.total

      if vis_lines[0].include?("½")
        runlines = vis_lines[0].split("½")
        spread = runlines[0].to_f 
        half = spread > 0 ? 0.5 : -0.5
        spread = (spread + half) * -1
        vis_rl = runlines[1].to_s.gsub("o", "").to_i
      elsif vis_lines[0].exclude?("Ov")
        spread = nil
        vis_rl = nil
        vis_ml = vis_lines[0].to_s.gsub("o", "").to_i
      else
        total = vis_lines[0].to_s.gsub("Ov", "").split(/[-,+]/)[0]
      end
      if vis_lines[1].present?
        if vis_lines[1].exclude?("Ov") && vis_lines[1].exclude?("Un")
          vis_ml = vis_lines[1].to_s.gsub("o", "").to_i
          total = vis_lines[2].to_s.gsub("Ov", "").split(/[-,+]/)[0] if vis_lines[2].present?
        else
          total = vis_lines[1].to_s.gsub("Ov", "").split(/[-,+]/)[0]
        end

        half = total.include?("½") ? 0.5 : 0
        total = total.to_f + half      
      end
      if home_lines[0].include?("½")
        runlines = home_lines[0].split("½")
        home_rl = runlines[1].to_s.gsub("o", "").to_i
      elsif home_lines[0].exclude?("Un")
        home_rl = nil
        home_ml = home_lines[0].to_s.gsub("o", "").to_i
      end
      if home_lines[1].present? && home_lines[1].exclude?("Ov") && home_lines[1].exclude?("Un")
        home_ml = home_lines[1].to_s.gsub("o", "").to_i
      end
      game.update spread: spread, home_ml: home_ml, home_rl: home_rl, 
                  visitor_ml: vis_ml, visitor_rl: vis_rl, total: total,
                  visitor_rot: home_rot.to_i - 1, home_rot: home_rot
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

end