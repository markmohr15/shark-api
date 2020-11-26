class BetOnlineLines::Nfl < BetOnlineLines::Base

  def self.url
    @url ||= "https://www.betonline.ag/sportsbook/football/nfl"
  end

  def self.sport
    @sport ||= Sport.find_by_abbreviation "NFL"
  end

  def self.team name
    sport.teams.find_by_nickname(name.last) || sport.teams.find_by_nickname(name[-2..-1].join(" "))
  end

  def self.get_lines
    @url = @fetch = @base_dates = @base_games = @dates = @games = nil

    return if base_dates.empty?
    date = dates[0][0][0].split(" -")[0].to_date
    date2 = dates[dates.size - 1][0][0].split(" -")[0].to_date
    games.each do |g|
      next if g[0][0].blank?
      game_info = game_info g
      next if game_info[:vis_lines].empty? || game_info[:home_lines].empty?
      game = Game.Scheduled.where('sport_id = ? and gametime > ? and gametime < ? and visitor_id = ? and home_id = ?', 
                         sport.id, date.to_datetime, date2.to_datetime.end_of_day + 6.hours, 
                         team(game_info[:vis_name])&.id, team(game_info[:home_name])&.id).first
      next if game.nil?
      create_line game_info, game
    end
  rescue StandardError => exception
    raise_api_error exception.message
  end

end