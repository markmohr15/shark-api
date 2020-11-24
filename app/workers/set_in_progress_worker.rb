class SetInProgressWorker
  include Sidekiq::Worker

  def perform game_id
    game = Game.find game_id
    if game.status == "Scheduled"
      game.update status: "InProgress"
    end
    game.triggers.open.update_all status: "expired"
  end
end
