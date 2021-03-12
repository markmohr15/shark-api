class BookmakerLines::Mlb < BookmakerLines::Base

  def self.url
    @url ||= "https://www.bookmaker.eu/live-lines/baseball/major-league-baseball"
  end

  def self.sport
    @sport ||= Sport.mlb
  end

  def self.get_lines
    @url = @fetch = @base_times = @times = @base_teams = @teams = @base_spreads = nil
    @spread = @base_totals = @totals = @base_moneylines = @moneylines = nil
    @nf = []

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

end