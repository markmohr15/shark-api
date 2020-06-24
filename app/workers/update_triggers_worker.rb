class UpdateTriggersWorker
  include Sidekiq::Worker

  def perform(game_id)
    game = Game.find game_id
    triggers = game.triggers
    triggers.open.spread.greater_eq.where('target <= ? and triggers.team_id = ?', g.spread, g.home_id).map {|x| x.update(status: "triggered")}
    triggers.open.spread.less_eq.where('target >= ? and triggers.team_id = ?', g.spread, g.home_id).map {|x| x.update(status: "triggered")}
    triggers.open.spread.greater_eq.where('target <= ? and triggers.team_id = ?', g.spread * -1, g.visitor_id).map {|x| x.update(status: "triggered")}
    triggers.open.spread.greater_eq.where('target >= ? and triggers.team_id = ?', g.spread * -1, g.visitor_id).map {|x| x.update(status: "triggered")}
    triggers.open.total.greater_eq.where('target <= ?', g.total).map {|x| x.update(status: "triggered")}
    triggers.open.total.less_eq.where('target >= ?', g.total).map {|x| x.update(status: "triggered")}
    triggers.open.moneyline.greater_eq.where('target <= ? and triggers.team_id = ?', g.home_ml, g.home_id).map {|x| x.update(status: "triggered")}
    triggers.open.moneyline.less_eq.where('target >= ? and triggers.team_id = ?', g.home_ml, g.home_id).map {|x| x.update(status: "triggered")}
    triggers.open.moneyline.greater_eq.where('target <= ? and triggers.team_id = ?', g.visitor_ml, g.visitor_id).map {|x| x.update(status: "triggered")}
    triggers.open.moneyline.less_eq.where('target >= ? and triggers.team_id = ?', g.visitor_ml, g.visitor_id).map {|x| x.update(status: "triggered")}
    triggers.open.runline.greater_eq.where('target <= ? and triggers.team_id = ?', g.home_rl, g.home_id).map {|x| x.update(status: "triggered")}
    triggers.open.runline.less_eq.where('target >= ? and triggers.team_id = ?', g.home_rl, g.home_id).map {|x| x.update(status: "triggered")}
    triggers.open.runline.greater_eq.where('target <= ? and triggers.team_id = ?', g.visitor_rl, g.visitor_id).map {|x| x.update(status: "triggered")}
    triggers.open.runline.less_eq.where('target >= ? and triggers.team_id = ?', g.visitor_rl, g.visitor_id).map {|x| x.update(status: "triggered")}
  end
end
