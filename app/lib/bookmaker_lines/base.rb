class BookmakerLines::Base

  def self.raise_api_error err
    Sidekiq.logger.info err
    Bugsnag.notify err
    nil
  end

  def self.agent
    @agent ||= Mechanize.new
  end

  def self.sportsbook
    @sportsbook ||= Sportsbook.find_by_name "Bookmaker"
  end

  def self.fetch
    @fetch ||= agent.get(url)
  end

  def self.base_times
    @base_times ||= fetch.search(".time")
  end

  def self.times
    @times ||= base_times.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.flatten
  end

  def self.base_teams
    @base_teams ||= fetch.search(".team")
  end

  def self.teams
    @teams ||= base_teams.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.flatten
  end

  def self.base_spreads
    @base_spreads ||= fetch.search(".spread")
  end

  def self.spreads
    @spreads ||= self.base_spreads.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.flatten.reject { |x| x == "Line"}.map {|x| x == "-" ? nil : x}
  end

  def self.base_totals
    @base_totals ||= fetch.search(".total")
  end

  def self.totals
    @totals ||= base_totals.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.flatten.reject { |x| x == "Total"}.map {|x| x == "-" ? nil : x}
  end

  def self.base_moneylines
    @base_moneylines ||= fetch.search(".money")
  end

  def self.moneylines
    @moneylines ||= base_moneylines.map do |node|
      node.children.map{|n| [n.text.strip] if n.elem? }.compact
    end.flatten.reject { |x| x == "Moneyline"}.map {|x| x == "-" ? nil : x}
  end

  def self.get_lines
    @url = @fetch = @base_times = @times = @base_teams = @teams = @base_spreads = nil
    @spreads = @base_totals = @totals = @base_moneylines = @moneylines = nil
    @nf = []
    
    teams.each_with_index do |t,i|
      next if i % 2 == 1
      game = sport.games.Scheduled.where('home_id = ? and visitor_id = ?', 
                team(teams[i + 1])&.id, team(t)&.id).order(:gametime)&.first
      if game.nil?
        @nf << t
      else
        vis_spread = parse_vis_spread spreads[i]
        over_total = parse_total(totals[i])
        game.lines.create! visitor_spread: vis_spread[0], 
                          visitor_rl: vis_spread[1],
                          home_rl: parse_home_spread(spreads[i + 1]),
                          visitor_ml: parse_moneyline(moneylines[i]),
                          home_ml: parse_moneyline(moneylines[i + 1]), 
                          total: over_total[0],
                          over_odds: over_total[1],
                          under_odds: parse_total(totals[i + 1])[1],
                          game: game, sportsbook: sportsbook
      end
    end
    @nf
  rescue StandardError => exception
    raise_api_error exception.message
  end

  def self.team name
    sport.tags.find_by_name(name.gsub("Action", "").strip)&.team
  end

  def self.parse_vis_spread vis_spread
    if vis_spread.blank? || vis_spread == "-"
      [nil, nil]
    elsif vis_spread.include? "pk"   #have to check what they use
      [0, vis_spread.gsub("pk","").to_i]
    elsif vis_spread.include? "Â½"
      runlines = vis_spread.split("Â½")
      spread = runlines[0].to_f
      half = spread > 0 ? 0.5 : -0.5
      [spread + half, runlines[1].to_i]
    else
      split_index = vis_spread[1..-1].index(/[+ -]/)
      [vis_spread[0..split_index].to_f, 
       vis_spread[split_index + 1..-1].to_i]
    end
  end

  def self.parse_home_spread home_spread
    if home_spread.blank? || home_spread == "-"
      nil
    elsif home_spread.include? "pk"   #have to check what they use
      home_spread.gsub("pk","").to_i
    elsif home_spread.include? "Â½"
      home_spread.split("Â½")[1].to_i
    else
      split_index = home_spread[1..-1].index(/[+ -]/)
      home_spread[split_index + 1..-1].to_i
    end
  end

  def self.parse_total total
    return nil if total.blank? || total == "-"
    num = total.gsub("o", "").split(/[-,+]/)[0]
    half = num.include?("½") ? 0.5 : 0
    [num.to_f + half, total.split(num)[1]] 
  end

  def self.parse_moneyline moneyline
    return nil if moneyline.blank? || moneyline == "-" 
    moneyline.gsub(" Â","").to_i
  end

end