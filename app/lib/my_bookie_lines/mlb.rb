class MyBookieLines::Mlb < MyBookieLines::Base

  def self.url
    @url ||= "https://mybookie.ag/sportsbook/mlb/"
  end

  def self.sport
    @sport ||= Sport.mlb
  end

  def self.team name
    name = name.split(" ")
    sport.tags.find_by_name(name[0..1])&.team || sport.tags.find_by_name(name[0..2])&.team
  end

  def self.get_lines
    @url = @fetch = @games = nil
    @nf = []
    @found = []

    games.each do |g|
      game_info = game_info g
      next if game_info[:next]
      game = sport.games.Scheduled.where.not(id: @found).where('home_id = ? and visitor_id = ? 
                                                                and gametime > ? and gametime < ?', 
                team(game_info[:home_name])&.id, team(game_info[:vis_name])&.id, game_info[:gametime] - 90.minutes,
                game_info[:gametime] + 90.minutes).first
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