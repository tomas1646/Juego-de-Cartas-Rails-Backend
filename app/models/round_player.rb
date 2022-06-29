class RoundPlayer < ApplicationRecord
  belongs_to :player
  belongs_to :round

  def has_card?(card)
    cards.include?(card)
  end

  def remove_card(card)
    cards.delete(card)
    save
  end
end
