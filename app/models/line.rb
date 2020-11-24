# == Schema Information
#
# Table name: lines
#
#  id             :bigint           not null, primary key
#  home_ml        :integer
#  home_rl        :integer
#  home_spread    :float
#  total          :float
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
#  index_lines_on_game_id        (game_id)
#  index_lines_on_sportsbook_id  (sportsbook_id)
#
class Line < ApplicationRecord
  belongs_to :game
  belongs_to :sportsbook

  before_save :validate_ml_rl, :set_home_spread
  after_create :update_triggers

  scope :user_last_lines, -> (user, game) { joins(:sportsbook)
                                            .merge(user.sportsbooks)
                                            .where(game: game)
                                            .select("DISTINCT ON (sportsbook_id) lines.*")
                                            .order("lines.sportsbook_id, lines.created_at DESC") }


  def validate_ml_rl
    home_ml = nil if home_ml.present? && home_ml > -100 && home_ml < 100
    home_rl = nil if home_rl.present? && home_rl > -100 && home_rl < 100
    visitor_ml = nil if visitor_ml.present? && visitor_ml > -100 && visitor_ml < 100
    visitor_rl = nil if visitor_rl.present? && visitor_rl > -100 && visitor_rl < 100
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

end
