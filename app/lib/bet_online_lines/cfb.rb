class BetOnlineLines::Cfb < BetOnlineLines::Base

  URL = "https://classic.betonline.ag/sportsbook/football/ncaa"

  def self.sport
    @sport ||= Sport.cfb
  end

  def self.team name
    tag = sport.tags.find_by_name(name.join(" ")) || sport.tags.find_by_name(name[0..1].join(" ")) || 
          sport.tags.find_by_name(name[0..2].join(" ")) || sport.tags.find_by_name(name[0])
    tag&.team
  end
  
  def self.get_lines
    @url = @fetch = @base_dates = @base_games = @dates = @games = nil

    return if base_dates.empty?
    date = dates[0][0][0].split(" -")[0].to_date
    date2 = dates[dates.size - 1][0][0].split(" -")[0].to_date
    @nf = []
    @found = []
    games.each do |g|
      next if g[0][0].blank?
      game_info = game_info g
      next if game_info[:vis_lines].empty? || game_info[:home_lines].empty?
      game = Game.where.not(id: @found).Scheduled.where('sport_id = ? and gametime > ? and gametime < ? and home_id = ? and visitor_id = ?', 
                         sport.id, date.to_datetime, date2.to_datetime.end_of_day + 6.hours, 
                         team(game_info[:home_name])&.id, team(game_info[:vis_name])&.id).first
      if game.nil?
        @nf << game_info[:home_name]
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