class DeleteWeathersWorker
  include Sidekiq::Worker

  def perform game_id
    game = Game.find game_id
    gametime_weather = Weather.current.order(:created_at).last.pluck :id
    game.weathers.where.not(id: gametime_weather).map &:destroy
  end
end
