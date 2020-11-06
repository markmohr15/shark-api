class BookmakerLines::Cfb < BookmakerLines::Base

  def self.url
    @url ||= "https://www.bookmaker.eu/live-lines/football/college-football"
  end

  def self.sport
    @sport ||= Sport.find_by_abbreviation "CFB"
  end

  def self.team name
    sport.teams.find_by_bookmaker_name name
  end

  def self.get_lines
    teams.each_with_index do |t,i|
      next if i % 2 == 1
      game = sport.games.Scheduled.where('home_id = ? and visitor_id = ?', 
                team(teams[i + 1])&.id, team(t)&.id).first
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