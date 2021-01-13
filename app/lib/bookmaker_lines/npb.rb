class BookmakerLines::Npb < BookmakerLines::Base

  def self.url
    @url ||= "https://www.bookmaker.eu/live-lines/baseball/japan-professionalbaseball"
  end

  def self.sport
    @sport ||= Sport.npb
  end

  def self.team name
    sport.teams.find_by_bookmaker_name name.gsub("Action", "").strip
  end

  def self.get_lines
    @url = @fetch = @base_times = @times = @base_teams = @teams = @base_spreads = nil
    @spreads = @base_totals = @totals = @base_moneylines = @moneylines = nil

    teams.each_with_index do |t,i|
      next if i % 2 == 1
      gametime = "#{times[i / 2]} PDT".to_datetime
      game = sport.games.Scheduled.where('home_id = ? and visitor_id = ? and gametime >= ? and gametime <= ?', 
                team(teams[i + 1])&.id, team(t)&.id, gametime - 70.minutes, gametime + 70.minutes).first
      if game.nil?
        gametime += 1.day
        game = sport.games.Scheduled.where('home_id = ? and visitor_id = ? and gametime >= ? and gametime <= ?', 
                team(teams[i + 1])&.id, team(t)&.id, gametime - 70.minutes, gametime + 70.minutes).first
      end
      next if game.nil?
      vis_spread = parse_vis_spread spreads[i]
      game.lines.create! visitor_spread: vis_spread[0], 
                        visitor_rl: vis_spread[1],
                        home_rl: parse_home_spread(spreads[i + 1]),
                        visitor_ml: parse_moneyline(moneylines[i]),
                        home_ml: parse_moneyline(moneylines[i + 1]), 
                        total: parse_total(totals[i]),
                        game: game, sportsbook: sportsbook
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

end