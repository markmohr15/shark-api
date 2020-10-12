class BetOnlineLines::Base

  def self.raise_api_error err
    Sidekiq.logger.info err
    Bugsnag.notify err
    nil
  end

  def self.agent
    Mechanize.new
  end

  def self.base_dates
    self.agent.get(self.url).search(".date")
  end

  def self.base_games
    self.agent.get(self.url).search(".event")
  end

  def self.dates
    dates ||= self.base_dates.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end
  end

  def self.games
    games ||= self.base_games.map do |node|
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
      next if x.length < 3
      if x[0] == "-" || x[0] == "+" || x[0..1] == "pk" || x[0..1] == "Ov" || x[0..1] == "Un"
        vis_lines << x
      else
        vis_name << x
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
    {vis_lines: vis_lines, home_lines: home_lines, vis_name: vis_name, 
     home_name: home_name, home_rot: home_rot, time: top[0], 
     time_adjust: top[1][0..1] == "PM" && top[0][0..1] != "12" ? 12 : 0}
  end

  def self.parse_vis_line vl
    if vl.include? "Ov"
      total = vl.gsub("Ov", "").split(/[-,+]/)[0]
      half = total.include?("½") ? 0.5 : 0
      {total: total.to_f + half}
    elsif vl.include? "pk"
      {spread: 0, vis_rl: vl.gsub("pk", "").gsub("o", "").to_i}
    elsif vl.scan(/[+ -]/).length == 1
      {vis_ml: vl.gsub("o", "").to_i}
    else
      if vl.include? "½"
        runlines = vl.split("½")
        spread = runlines[0].to_f 
        half = spread > 0 ? 0.5 : -0.5
        spread = (spread + half) * -1
        {spread: spread, vis_rl: runlines[1].gsub("o", "").to_i}
      else
        split_index = vl[1..-1].index(/[+ -]/)
        {spread: vl[0..split_index].to_f * -1,
         vis_rl: vl[split_index + 1..-1].gsub("o", "").to_i}
      end
    end
  end

  def self.parse_home_line hl
    if hl.include? "Un"
      {}
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

end