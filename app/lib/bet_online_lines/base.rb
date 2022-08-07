require 'open-uri'

class BetOnlineLines::Base

  def self.raise_api_error err
    Sidekiq.logger.info err
    Bugsnag.notify err
    nil
  end

  def self.sportsbook
    @sportsbook ||= Sportsbook.find_by_name "BetOnline"
  end

  def self.fetch
    @fetch ||= Nokogiri::HTML(URI.open(url))
  end

  def self.base_dates
    @base_dates ||= fetch.search(".date")
  end

  def self.base_games
    @base_games ||= fetch.search(".event")
  end

  def self.dates
    @dates ||= base_dates.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
  end

  def self.games
    @games ||= base_games.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
  end

  def self.game_info game
    top = game[0][0].gsub("\n", "").split(" ")
    bottom = game[1][0].gsub("\n", "").split(" ")
    home_rot = bottom[0].delete("^0-9")
    vis_name = [top[1][2 + home_rot.size..-1]]
    home_name = [bottom[0][home_rot.size..-1]]
    vis_lines = []
    home_lines = []
    top[2..-1].each do |x|
      next if x == "-" || x == "-R" || x == "-L"
      if x[0] == "-" || x[0] == "+" || x[0..1] == "pk" || x[0..1] == "Ov" || (x[0..1] == "Un" && x.exclude?(","))
        vis_lines << x
      else
        vis_name << x
      end
    end
    bottom[1..-1].each do |x|
      next if x == "Game" || x == "-R" || x == "-L"
      if x[0] == "-" || x[0] == "+" || x[0..1] == "pk" || x[0..1] == "Ov" || (x[0..1] == "Un" && x.exclude?(","))
        home_lines << x
      else
        home_name << x
      end
    end
    home_rot_index = home_rot.size > 3 ? -4 : 0
    {vis_lines: vis_lines, home_lines: home_lines, vis_name: vis_name, 
     home_name: home_name, home_rot: home_rot[home_rot_index..-1], time: top[0], 
     time_adjust: top[1][0..1] == "PM" && top[0][0..1] != "12" ? 12 : 0}
  end

  def self.parse_vis_line vl
    if vl.include? "Ov"
      total = vl.gsub("Ov", "").split(/[-,+]/)[0]
      juice = vl.split(total, 2)[1]
      half = total.include?("½") ? 0.5 : 0
      {total: total.to_f + half, over_juice: juice}
    elsif vl.include? "pk"
      {vis_spread: 0, vis_rl: vl.gsub("pk", "").gsub("o", "").to_i}
    elsif vl.scan(/[+ -]/).length == 1
      {vis_ml: vl.gsub("o", "").to_i}
    else
      if vl.include? "½"
        runlines = vl.split("½")
        spread = runlines[0].to_f 
        half = spread > 0 ? 0.5 : -0.5
        spread = (spread + half)
        {vis_spread: spread, vis_rl: runlines[1].gsub("o", "").to_i}
      else
        split_index = vl[1..-1].index(/[+ -]/)
        {vis_spread: vl[0..split_index].to_f,
         vis_rl: vl[split_index + 1..-1].gsub("o", "").to_i}
      end
    end
  end

  def self.parse_home_line hl
    if hl.include? "Un"
      total = hl.gsub("Un", "").split(/[-,+]/)[0]
      juice = hl.split(total, 2)[1]
      {under_juice: juice}
    elsif hl.include? "pk"
      {home_rl: hl.gsub("pk", "").gsub("o", "").to_i}
    elsif hl.scan(/[+ -]/).length == 1
      {home_ml: hl.gsub("o", "").to_i}
    else
      if hl.include? "½"
        runlines = hl.split("½")
        {home_rl: runlines[1].gsub("o", "").to_i}
      else
        split_index = hl[1..-1].index(/[+ -]/)
        {home_rl: hl[split_index + 1..-1].gsub("o", "").to_i}
      end
    end
  end

  def self.create_line game_info, game
    total_set = false
    lines = {vis_spread: nil, vis_rl: nil, vis_ml: nil, 
             home_rl: nil, home_ml: nil, total: nil,
             over_juice: nil, under_juice: nil}

    game_info[:vis_lines][0..2].each do |vl|
      next if vl.include?("Ov") && total_set
      lines.merge!(self.parse_vis_line(vl))
      total_set = true if vl.include? "Ov"
    end
    game_info[:home_lines][0..2].each do |hl|
      lines.merge!(self.parse_home_line(hl))
    end
    game.update home_rot: game_info[:home_rot]
    game.lines.create visitor_spread: lines[:vis_spread], home_ml: lines[:home_ml], 
                      home_rl: lines[:home_rl], visitor_ml: lines[:vis_ml],
                      visitor_rl: lines[:vis_rl], total: lines[:total],
                      over_odds: lines[:over_juice], under_odds: lines[:under_juice],
                      game: game, sportsbook: sportsbook
  end

end