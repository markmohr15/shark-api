class BetOnlineLines::Nba < BetOnlineLines::Base
  
  def self.get_lines
    sport = Sport.find_by_abbreviation 'NBA'
    agent = Mechanize.new
    base_dates = agent.get("https://www.betonline.ag/sportsbook/basketball/nba").search(".date")
    base_games = agent.get("https://www.betonline.ag/sportsbook/basketball/nba").search(".event")
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
      game = Game.where('sport_id = ? and gametime >= ? and gametime <= ? and home_id = ?', 
                         sport.id, "#{date} #{time}:00 EDT -04:00".to_datetime - 70.minutes + time_adjust.hours,
                         "#{date} #{time}:00 EDT -04:00".to_datetime + 70.minutes + time_adjust.hours,
                        home&.id).first
      
      if game.nil? && dates.size < 2
        next
      elsif game.nil?
        game = Game.where('sport_id = ? and gametime >= ? and gametime <= ? and home_id = ?', 
                         sport.id, "#{date2} #{time}:00 EDT -04:00".to_datetime - 70.minutes + time_adjust.hours,
                         "#{date2} #{time}:00 EDT -04:00".to_datetime + 70.minutes + time_adjust.hours,
                         home&.id).first
      end
      next if game.nil?

      spread = game.spread
      vis_rl = game.visitor_rl
      vis_ml = game.visitor_ml
      home_rl = game.home_rl
      home_ml = game.home_ml
      total = game.total

      vis_lines[0..2].each do |vl|
        if vl.include? "Ov"
          total = vl.gsub("Ov", "").split(/[-,+]/)[0]
          half = total.include?("½") ? 0.5 : 0
          total = total.to_f + half
        elsif vl.include? "pk"
          spread = 0
          vis_rl = vl.gsub("pk", "").gsub("o", "").to_i
          vis_ml = vis_rl
        elsif vl.scan(/[+ -]/).length == 1
          vis_ml = vl.gsub("o", "").to_i
        else
          if vl.include? "½"
            runlines = vl.split("½")
            spread = runlines[0].to_f 
            half = spread > 0 ? 0.5 : -0.5
            spread = (spread + half) * -1
            vis_rl = runlines[1].gsub("o", "").to_i
          else
            split_index = vl[1..-1].index(/[+ -]/)
            spread = vl[0..split_index].to_f * -1
            vis_rl = vl[split_index + 1..-2].to_i
          end
        end
      end
      home_lines[0..2].each do |hl|
        if hl.include? "Un"
        elsif hl.include? "pk"
          home_rl = hl.gsub("pk", "").gsub("o", "").to_i
          home_ml = home_rl
        elsif hl.scan(/[+ -]/).length == 1
          home_ml = hl.gsub("o", "").to_i
        else
          if hl.include? "½"
            runlines = hl.split("½")
            home_rl = runlines[1].gsub("o", "").to_i
          else
            split_index = hl[1..-1].index(/[+ -]/)
            home_rl = hl[split_index + 1..-2].to_i
          end
        end
      end
      game.update spread: spread, home_ml: home_ml, home_rl: home_rl, 
                  visitor_ml: vis_ml, visitor_rl: vis_rl, total: total,
                  visitor_rot: home_rot.to_i - 1, home_rot: home_rot
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

end