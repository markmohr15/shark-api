class DeleteWeathersWorker
  include Sidekiq::Worker

  def perform game_id
    game = Game.find game_id
    gametime_weather = game.weathers.current.order(:created_at).last&.id
    game.weathers.where.not(id: gametime_weather).delete_all
  end
end
