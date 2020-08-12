class SetInProgressWorker
  include Sidekiq::Worker

  def perform game_id
    game = Game.find game_id
    game.update status: "InProgress"
    game.triggers.open.update_all status: "expired"
  end
end
