class Round < ApplicationRecord # rubocop:disable Metrics/ClassLength
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
    start_new_round_validations

    self.status = :waiting_card_throw
    save
    create_turn
  end

  def create_turn
    arr = order_player_ids
    game_created = Game.create(game_number: games.size)
    game_created.create_turns arr
    games.push(game_created)
  end

  def order_player_ids
    arr = players_ids
    unless games.empty?
      last_winner_id = games.last.winner_id
      arr.rotate!(arr.find_index(last_winner_id))
    end
    arr
  end

  def throw_card(player_id, card)
    throw_card_validations(player_id)

    round_player = round_players.find { |rp| rp.player_id == player_id }

    raise "Player doesnt have the card #{card}" unless round_player.has_card?(card)

    games.last.throw_card player_id, card

    round_player.remove_card(card)

    # if all player throw cards and someone win
    finish_game if games.last.finished?
  end

  def finish_game
    # add the win to the player
    winner_id = games.last.winner_id
    round_players.find { |rp| rp.player_id == winner_id }.increment!(:current_wins)

    # if it was the last game this round must finish
    if games.size == number_of_cards
      self.status = :finished
    else
      create_turn
    end
    save
  end

  def players_ids_and_lost_number
    arr = []
    round_players.each do |rp|
      p_id = rp.player_id

      lost_number = (rp.bet_wins - rp.current_wins).abs

      arr.push({ id: p_id, lost: lost_number })
    end
    arr
  end

  def bet_win(player_id, win_number)
    raise 'Player isnt in round' unless player_in_round?(player_id)
    raise 'Round status isnt Ask Bet' unless waiting_bet_asked?

    @round_player = round_players.find { |rp| rp.player_id == player_id }

    check_last_player_bet(win_number)

    @round_player.update(bet_wins: win_number)

    start_card_round if all_bet?
  end

  def player_cards(player_id)
    raise 'Player isnt in round' unless player_in_round?(player_id)

    round_players.find { |rp| rp.player_id == player_id }.cards
  end

  def player_in_round?(player_id)
    round_players.any? { |rp| rp.player_id == player_id }
  end

  def all_bet?
    round_players.all? { |rp| rp.bet_wins.present? }
  end

  def all_play?
    games.last.all_play?
  end

  def players_ids
    round_players.map(&:player_id)
  end

  private

  def throw_card_validations(player_id)
    raise 'Round status isnt Throw Card' unless waiting_card_throw?
    raise 'Player isnt in round' unless player_in_round?(player_id)
    raise 'Player already throw a card' if games.last.player_throw_card?(player_id)
  end

  def start_new_round_validations
    return if games.empty?

    raise 'Before starting a new round, all players must throw cards' unless all_play?
  end

  def check_last_player_bet(win_number)
    last_player_bet_position = round_players.max_by(&:bet_position).bet_position

    return if @round_player.bet_position != last_player_bet_position

    all_player_except_last_bet?(win_number, last_player_bet_position)
  end

  def all_player_except_last_bet?(win_number, last_player_bet_position)
    players_bets_without_last = round_players.filter do |rp|
      rp.bet_position != last_player_bet_position
    end.map(&:bet_wins)

    raise 'All players must bet before the last player can bet' if players_bets_without_last.any?(&:nil?)

    sum = players_bets_without_last.sum

    return unless (sum + win_number) == number_of_cards

    raise 'The sum of the bets cant be equal to the number of cards in the round'
  end
end
