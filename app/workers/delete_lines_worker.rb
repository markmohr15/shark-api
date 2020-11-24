class DeleteLinesWorker
  include Sidekiq::Worker

  def perform game_id
    game = Game.find game_id
    game.lines.destroy_all
  end
end
