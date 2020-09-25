class UpdateTriggersWorker
  include Sidekiq::Worker

  def perform(game_id)
    g = Game.find game_id
    triggers = g.triggers
    if g.spread.present?
      triggers.open.spread.greater_eq.where('target <= ? and triggers.team_id = ?', g.spread, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.open.spread.less_eq.where('target >= ? and triggers.team_id = ?', g.spread, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.open.spread.greater_eq.where('target <= ? and triggers.team_id = ?', g.spread * -1, g.visitor_id).map {|x| x.update(status: "triggered")}
      triggers.open.spread.greater_eq.where('target >= ? and triggers.team_id = ?', g.spread * -1, g.visitor_id).map {|x| x.update(status: "triggered")}
    end
    if g.total.present?
      triggers.open.total.greater_eq.where('target <= ?', g.total).map {|x| x.update(status: "triggered")}
      triggers.open.total.less_eq.where('target >= ?', g.total).map {|x| x.update(status: "triggered")}
    end
    if g.home_ml.present? && g.visitor_ml.present?
      triggers.open.moneyline.greater_eq.where('target <= ? and triggers.team_id = ?', g.home_ml, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.open.moneyline.less_eq.where('target >= ? and triggers.team_id = ?', g.home_ml, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.open.moneyline.greater_eq.where('target <= ? and triggers.team_id = ?', g.visitor_ml, g.visitor_id).map {|x| x.update(status: "triggered")}
      triggers.open.moneyline.less_eq.where('target >= ? and triggers.team_id = ?', g.visitor_ml, g.visitor_id).map {|x| x.update(status: "triggered")}
    end
    if g.home_rl.present? && g.visitor_rl.present?
      triggers.open.runline.greater_eq.where('target <= ? and triggers.team_id = ?', g.home_rl, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.open.runline.less_eq.where('target >= ? and triggers.team_id = ?', g.home_rl, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.open.runline.greater_eq.where('target <= ? and triggers.team_id = ?', g.visitor_rl, g.visitor_id).map {|x| x.update(status: "triggered")}
      triggers.open.runline.less_eq.where('target >= ? and triggers.team_id = ?', g.visitor_rl, g.visitor_id).map {|x| x.update(status: "triggered")}
    end
  end
end
