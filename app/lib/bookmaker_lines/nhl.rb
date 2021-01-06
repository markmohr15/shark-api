class BookmakerLines::Nhl < BookmakerLines::Base

  def self.url
    @url ||= "https://www.bookmaker.eu/live-lines/hockey/nhl"
  end

  def self.sport
    @sport ||= Sport.find_by_abbreviation "NHL"
  end

  def self.team name
    sport.teams.find_by_bookmaker_name name
  end

  def self.get_lines
    @url = @fetch = @base_times = @times = @base_teams = @teams = @base_spreads = nil
    @spreads = @base_totals = @totals = @base_moneylines = @moneylines = nil
    @nf = []
    
    teams.each_with_index do |t,i|
      next if i % 2 == 1
      game = sport.games.Scheduled.where('home_id = ? and visitor_id = ?', 
                team(teams[i + 1])&.id, team(t)&.id).first
      if game.nil?
        @nf << t
      else
        vis_spread = parse_vis_spread spreads[i]
        game.lines.create! visitor_spread: vis_spread[0], 
                          visitor_rl: vis_spread[1],
                          home_rl: parse_home_spread(spreads[i + 1]),
                          visitor_ml: parse_moneyline(moneylines[i]),
                          home_ml: parse_moneyline(moneylines[i + 1]), 
                          total: parse_total(totals[i]),
                          game: game, sportsbook: sportsbook
      end
    end
    @nf
  rescue StandardError => exception
    raise_api_error exception.message
  end
  
end