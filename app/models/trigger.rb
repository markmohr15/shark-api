# == Schema Information
#
# Table name: triggers
#
#  id         :bigint           not null, primary key
#  operator   :integer
#  status     :integer          default("open")
#  target     :float
#  wager_type :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  team_id    :bigint           not null
#  user_id    :bigint
#
# Indexes
#
#  index_triggers_on_game_id  (game_id)
#  index_triggers_on_team_id  (team_id)
#  index_triggers_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (team_id => teams.id)
#  fk_rails_...  (user_id => users.id)
#

class Trigger < ApplicationRecord
  belongs_to :game
  belongs_to :team
  belongs_to :user

  enum operator: { greater_eq: 0, less_eq: 1 }
  enum status: { open: 0, triggered: 1, expired: 2, canceled: 3 }
  enum wager_type: { spread: 0, total: 1, moneyline: 2, runline: 3 }

  validates_presence_of :target, :operator, :status, :wager_type
  validate :game_open, on: :create
  validate :valid_target, on: :create

  scope :active, -> {where status: 0}
  scope :executed, -> {where status: 1}
  scope :expd, -> {where status: 2}
  scope :cxld, -> {where status: 3}

  def game_open
    errors.add(:base, "Game is not open") unless game.Scheduled?
  end

  def valid_target
    if greater_eq?
      case wager_type 
      when "spread"
        if team == game.visitor && game.spread * -1 >= target
          errors.add(:base, "Target must be better than the current spread")
        elsif team == game.home && game.spread >= target
          errors.add(:base, "Target must be better than the current spread")
        end
      when "total"
        errors.add(:base, "Target must be higher than the current total") if game.total >= target
      when "moneyline"
        if team == game.visitor && game.visitor_ml >= target
          errors.add(:base, "Target must be better than the current moneyline")
        elsif team == game.home && game.home_ml >= target
          errors.add(:base, "Target must be better than the current moneyline")
        end
      when "runline"
        if team == game.visitor && game.visitor_rl >= target
          errors.add(:base, "Target must be better than the current runline")
        elsif team == game.home && game.home_rl >= target
          errors.add(:base, "Target must be better than the current runline")
        end
      end
    else
      case wager_type
      when "spread"
        if team == game.visitor && game.spread * -1 <= target
          errors.add(:base, "Target must be worse than the current spread")
        elsif team == game.home && game.spread <= target
          errors.add(:base, "Target must be worse than the current spread")
        end
      when "total"
        errors.add(:base, "Target must be lower than the current total") if game.total <= target
      when "moneyline"
        if team == game.visitor && game.visitor_ml <= target
          errors.add(:base, "Target must be worse than the current moneyline")
        elsif team == game.home && game.home_ml <= target
          errors.add(:base, "Target must be worse than the current moneyline")
        end
      when "runline"
        if team == game.visitor && game.visitor_rl <= target
          errors.add(:base, "Target must be worse than the current runline")
        elsif team == game.home && game.home_rl <= target
          errors.add(:base, "Target must be worse than the current runline")
        end
      end
    end
  end

end
