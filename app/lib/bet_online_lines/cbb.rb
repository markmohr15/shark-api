class BetOnlineLines::Cbb < BetOnlineLines::Base

  def self.url
    @url ||= "https://classic.betonline.ag/sportsbook/basketball/ncaa"
  end

  def self.sport
    @sport ||= Sport.cbb
  end

  def self.home home_name
    sport.tags.find_by_name(home_name.join(" "))&.team
  end
  
  def self.get_lines
    @url = @fetch = @base_dates = @base_games = @dates = @games = nil
    @nf = []
    @found = []

    return if base_dates.empty?
    date = dates[0][0][0].split(" -")[0].to_date
    date2 = dates[dates.size - 1][0][0].split(" -")[0].to_date
    games.each do |g|
      next if g[0][0].blank?
      game_info = game_info g
      next if game_info[:vis_lines].empty? || game_info[:home_lines].empty?
      game = Game.Scheduled
                 .where.not(id: @found)
                 .where('sport_id = ? and gametime > ? and gametime < ? and home_id = ?', 
                         sport.id, date.to_datetime, date2.to_datetime.end_of_day + 6.hours, 
                         home(game_info[:home_name])&.id).first
      if game.nil?
        @nf << g
      else
        create_line game_info, game
        @found << game.id
      end
    end
    @nf
  rescue StandardError => exception
    raise_api_error exception.message
  end

end