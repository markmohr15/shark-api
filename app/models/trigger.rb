# == Schema Information
#
# Table name: triggers
#
#  id         :bigint           not null, primary key
#  gametime   :datetime
#  notified   :boolean          default(FALSE)
#  operator   :integer
#  status     :integer          default("open")
#  target     :float
#  wager_type :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  team_id    :bigint
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
  belongs_to :team, optional: true
  belongs_to :user

  enum operator: { greater_eq: 0, less_eq: 1 }
  enum status: { open: 0, triggered: 1, expired: 2, canceled: 3 }
  enum wager_type: { spread: 0, total: 1, moneyline: 2, runline: 3 }

  validates_presence_of :target, :operator, :status, :wager_type
  validates_presence_of :team, unless: Proc.new { |t| t.wager_type == "total"}
  validate :game_open, on: :create
  validate :valid_target, on: :create
  validate :valid_target, on: :update, if: Proc.new { |t| t.operator_changed? || t.target_changed? || 
                                                          t.wager_type_changed? || t.team_id_changed? }

  before_create do
    self.gametime = game.gametime
  end

  def self.allowed_scopes
    %w[open triggered expired canceled]
  end

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

  def display_target
    dt = target.to_s.gsub(/(\.)0+$/, '')
    case wager_type
    when "total"
      dt
    when "runline"
      if team == game.visitor
        return "#{game.display_visitor_spread} +#{dt}" if target > 0
        return "#{game.display_visitor_spread} #{dt}"
      else
        return "#{game.display_home_spread} +#{dt}" if target > 0
        return "#{game.display_home_spread} #{dt}"
      end
    else
      return "PK" if target == 0 && wager_type == "spread"
      return "+#{dt}" if target > 0
      dt
    end
  end

end
