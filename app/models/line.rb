# == Schema Information
#
# Table name: lines
#
#  id             :bigint           not null, primary key
#  home_ml        :integer
#  home_rl        :integer
#  home_spread    :float
#  over_odds      :integer
#  total          :float
#  under_odds     :integer
#  visitor_ml     :integer
#  visitor_rl     :integer
#  visitor_spread :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  game_id        :bigint
#  sportsbook_id  :bigint
#
# Indexes
#
#  index_lines_on_created_at     (created_at)
#  index_lines_on_game_id        (game_id)
#  index_lines_on_sportsbook_id  (sportsbook_id)
#
class Line < ApplicationRecord
  belongs_to :game
  belongs_to :sportsbook

  before_save :validate_line, :set_home_spread
  after_create :update_triggers

  scope :scheduled_last_lines, -> (user, game) { joins(:sportsbook)
                                            .merge(user.sportsbooks)
                                            .where('game_id = ? and lines.created_at > ?', game.id, (DateTime.current - 1.hour) )
                                            .select("DISTINCT ON (sportsbook_id) lines.*")
                                            .order("lines.sportsbook_id, lines.created_at DESC") }

  scope :completed_last_lines, -> (user, game) { joins(:sportsbook)
                                            .merge(user.sportsbooks)
                                            .where('game_id = ?', game.id)
                                            .select("DISTINCT ON (sportsbook_id) lines.*")
                                            .order("lines.sportsbook_id, lines.created_at DESC") }

  scope :first_or_last_lines, -> (game, direction) { joins(:sportsbook)
                                        .merge(Sportsbook.all)
                                        .where('game_id = ?', game.id)
                                        .select("DISTINCT ON (sportsbook_id) lines.*")
                                        .order("lines.sportsbook_id, lines.created_at #{direction}") }

  def validate_line
    self.home_ml = nil if home_ml.present? && home_ml > -100 && home_ml < 100
    self.home_rl = nil if home_rl.present? && home_rl > -100 && home_rl < 100
    self.visitor_ml = nil if visitor_ml.present? && visitor_ml > -100 && visitor_ml < 100
    self.visitor_rl = nil if visitor_rl.present? && visitor_rl > -100 && visitor_rl < 100
    self.total = nil if total.present? && total <= 0
  end

  def set_home_spread
    return if visitor_spread.blank?
    if visitor_spread == 0
      self.home_spread = 0
    else
      self.home_spread = visitor_spread * -1
    end
  end

  def update_triggers
    UpdateTriggersWorker.perform_async self.id
  end

  def self.user_last_lines user, game
    if game.Scheduled?
      scheduled_last_lines(user, game)
    else
      completed_last_lines(user, game)
    end
  end

end
