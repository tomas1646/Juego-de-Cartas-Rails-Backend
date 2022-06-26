class RoundPlayer < ApplicationRecord
  belongs_to :player
  belongs_to :round

  def add_one_curr_win
    self.current_wins += 1
    save
  end

  def has_card?(card)
    cards.include?(card)
  end

  def remove_card(card)
    cards.delete(card)
    save
  end
end
