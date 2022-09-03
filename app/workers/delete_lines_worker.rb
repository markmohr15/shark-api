class DeleteLinesWorker
  include Sidekiq::Worker

  def perform game_id
    game = Game.find game_id
    first_lines = Line.from(Line.first_or_last_lines(game, "ASC")).pluck :id
    last_lines = Line.from(Line.first_or_last_lines(game, "DESC")).pluck :id
    game.lines.where.not(id: first_lines + last_lines).delete_all
  end
end
