class BovadaLines::Mlb < BovadaLines::Base

  def self.url
    @url ||= "https://www.bovada.lv/services/sports/event/coupon/events/A/description/baseball/mlb?marketFilterId=def&preMatchOnly=true&lang=en"
    # @url ||= "https://www.bovada.lv/services/sports/event/coupon/events/A/description/baseball/mlb-exhibition?marketFilterId=def&preMatchOnly=true&lang=en"
  end

  def self.sport
    @sport ||= Sport.mlb
  end

  def self.get_lines
    @url = @fetch = @games = nil
    @nf = []
    @found = []

    games.each do |g|
      game_info = game_info g
      game = sport.games.Scheduled.where.not(id: @found)
                                  .where('gametime > ? and gametime < ? and home_id = ? and visitor_id = ?', 
                         game_info[:time] - 90.minutes, game_info[:time] + 90.minutes, 
                         team(game_info[:home_name])&.id, team(game_info[:vis_name])&.id).first
      if game.nil?
        @nf << [game_info[:vis_name], game_info[:home_name]]
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

