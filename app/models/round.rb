class Round < ApplicationRecord
  belongs_to :board
  has_many :round_players
  has_many :games
  has_many :turns, through: :games

  enum status: { waiting_bet_asked: 0, waiting_card_throw: 1, finished: 2 }

  def start_bet_round(players_id, cards)
    self.status = :waiting_bet_asked

    players_id.each_with_index do |player_id, index|
      round_players.push(RoundPlayer.new(player_id:, round: self, cards: cards[index], bet_position: index))
    end
  end

  def start_card_round
    return if waiting_bet_asked? && !all_bet?

    return unless can_start_new_round?

    self.status = :waiting_card_throw

    create_turn
  end

  def create_turn
    arr = players_ids
    if games.size != 0

      last_winner_id = games.last.winner_id
      arr.rotate!(arr.find_index(last_winner_id))
    end

    games.push(Game.new(round_number: games.size))
    games.last.create_turns arr
  end

  def throw_card(player_id, card)
    return unless can_throw_card?(player_id)

    round_players.map do |rp|
      next unless rp.player_id == player_id && rp.has_card?(card) && !games.last.player_throw_card?(player_id)

      games.last.throw_card player_id, card

      rp.remove_card(card)
    end

    # if all player throw cards and someone win
    finish_game if games.last.finished?
  end

  def finish_game
    # add the win to the player
    winner_id = games.last.winner_id
    round_players.find { |rp| rp.player_id == winner_id }.add_one_curr_win

    # if it was the last game this round must finish
    if games.size == (round_number(-1))
      self.status = :finished
    else
      create_turn
    end
  end

  def players_ids_and_lost_number
    arr = []
    round_players.each do |rp|
      p_id = rp.player_id

      lost_number = (round_players.bet_wins - round_players.current_wins).abs

      arr.push({ id: p_id, lost: lost_number })
    end
    arr
  end

  def set_bet(player_id, win_number)
    return if !player_in_round?(player_id) || !waiting_bet_asked?

    round_players.map do |rp|
      rp.bet win_number if rp.player_id == player_id
    end
  end

  def player_cards(player_id)
    return unless player_in_round?(player_id)

    round_players.find { |rp| rp.player_id == player_id }.cards
  end

  def player_in_round?(player_id)
    round_players.any? { |rp| rp.player_id == player_id }
  end

  def all_bet?
    round_players.any? { |rp| rp.bet_wins.nil? }
  end

  def all_play?
    games.last.all_play?
  end

  def players_ids
    round_players.map { |rp| rp.player_id }
  end

  private

  def can_throw_card?(player_id)
    waiting_card_throw? && (player_in_round? player_id)
  end

  def can_start_new_round?
    all_play? && games.size == (round_number(-1))
  end
end
