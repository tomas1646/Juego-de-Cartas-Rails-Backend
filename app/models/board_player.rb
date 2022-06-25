class BoardPlayer < ApplicationRecord
  belongs_to :player
  belongs_to :board

  enum status: { winner: 0, looser: 1 }

  def update_score(rounds_lost)
    self.score = Board::POINTS.slice(0, score.length + rounds_lost)
    update_status
  end

  def update_status
    self.status = :looser if score.length == Board::POINTS.length
  end
end
