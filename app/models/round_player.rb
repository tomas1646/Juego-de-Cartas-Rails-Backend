class RoundPlayer < ApplicationRecord
  belongs_to :player
  belongs_to :round

  def bet(win_number)
    self.bet_win = win_number
  end

  def add_one_curr_win
    self.current_wins += 1
  end

  def has_card?(card)
    cards.includes?(card)
  end

  def remove_card(card)
    return unless has_card?

    cards.delete(card)
  end
end
