class Game < ApplicationRecord
  belongs_to :round
  has_many :turns

  enum status: { in_course: 0, finished: 1 }

  def create_turns(players_ids)
    self.status = :in_course

    players_ids.each_with_index do |p_id, index|
      turns.push(Turn.create(player_id: p_id, card_played: '', player_position: index, game: self))
    end
    save
  end

  def throw_card(player_id, card)
    turn = turns.find { |ob| ob.player_id == player_id }

    turn.update(card_played: card)

    check_winner if all_play?
  end

  def check_winner
    card_array = []

    turns.each do |turn|
      card_array.push([turn.card_played, turn.player_position])
    end

    card_winner = Board.winner_card(card_array)

    turn_winner = turns.find { |turn| turn.card_played == card_winner[0] }

    self.status = :finished
    self.winner_id = turn_winner.player_id

    save
  end

  def all_play?
    turns.all? { |turn| turn.card_played.present? }
  end

  def player_throw_card?(player_id)
    turns.find { |turn| turn.player_id == player_id }.card_played.present?
  end
end
