class UpdateTriggersWorker
  include Sidekiq::Worker

  def perform(line_id)
    l = Line.find line_id
    g = l.game
    triggers = g.triggers.open.joins(:user).merge(l.sportsbook.users)
    if l.home_spread.present? && l.visitor_spread.present?
      triggers.spread.greater_eq.where('target <= ? and triggers.team_id = ?', l.home_spread, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.spread.less_eq.where('target >= ? and triggers.team_id = ?', l.home_spread, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.spread.greater_eq.where('target <= ? and triggers.team_id = ?', l.visitor_spread, g.visitor_id).map {|x| x.update(status: "triggered")}
      triggers.spread.less_eq.where('target >= ? and triggers.team_id = ?', l.visitor_spread, g.visitor_id).map {|x| x.update(status: "triggered")}
    end
    if l.total.present?
      triggers.total.greater_eq.where('target <= ?', l.total).map {|x| x.update(status: "triggered")}
      triggers.total.less_eq.where('target >= ?', l.total).map {|x| x.update(status: "triggered")}
    end
    if l.home_ml.present? && l.visitor_ml.present?
      triggers.moneyline.greater_eq.where('target <= ? and triggers.team_id = ?', l.home_ml, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.moneyline.less_eq.where('target >= ? and triggers.team_id = ?', l.home_ml, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.moneyline.greater_eq.where('target <= ? and triggers.team_id = ?', l.visitor_ml, g.visitor_id).map {|x| x.update(status: "triggered")}
      triggers.moneyline.less_eq.where('target >= ? and triggers.team_id = ?', l.visitor_ml, g.visitor_id).map {|x| x.update(status: "triggered")}
    end
    if l.home_rl.present? && l.visitor_rl.present?
      triggers.runline.greater_eq.where('target <= ? and triggers.team_id = ?', l.home_rl, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.runline.less_eq.where('target >= ? and triggers.team_id = ?', l.home_rl, g.home_id).map {|x| x.update(status: "triggered")}
      triggers.runline.greater_eq.where('target <= ? and triggers.team_id = ?', l.visitor_rl, g.visitor_id).map {|x| x.update(status: "triggered")}
      triggers.runline.less_eq.where('target >= ? and triggers.team_id = ?', l.visitor_rl, g.visitor_id).map {|x| x.update(status: "triggered")}
    end
  end
end
