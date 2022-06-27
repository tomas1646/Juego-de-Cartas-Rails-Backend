class Board < ApplicationRecord # rubocop:disable Metrics/ClassLength
  POINTS = :CALERA
  ROUNDS = [1, 2, 3, 4, 5].freeze

  before_create :create_deck, :set_token

  has_many :board_players
  has_many :rounds
  has_one :last_round, -> { order(rounds: :desc) }, class_name: 'Round'
  has_many :players, through: :board_players

  enum status: { waiting_players: 0, in_course: 1, finished: 2 }

  ##
  # Given an array of cards, with the card and the position in the board
  # the method return the winner card
  #
  # Example: given [["3-Or", 0], ["12-Or",1],["11-Es",2]]
  # return ["12-Or", 1]
  def self.winner_card(cards_position) # rubocop:disable Metrics/AbcSize
    # map card from string to integer value
    arr = cards_position.map { |cp| [cp[0].split('-')[0].to_i, cp[1]] }

    # get the maximum card
    max_card = arr.max_by { |it| it[0] }[0]

    # get the all the cards that has the highest card
    winner_cards = arr.select { |ob| ob[0] == max_card }

    # check if there is only one card with the max value
    winner_position = if winner_cards.size == 1
                        # only one card with the max value
                        winner_cards.first[1]
                      else
                        # if there is two cards with the max value, search the one that was played first
                        winner_cards.min_by { |it| it[1] }[1]
                      end

    cards_position.find { |ob| ob[1] == winner_position }
  end

  ##
  # Given the last two rounds of a board, calculates the next round number
  #
  # Example:
  # given [3,4], return 5
  # given [4,5], return 4
  # given [3,2], return 1
  def self.next_round_from_last_two_played(last_two_rounds)
    if (last_two_rounds[0] - last_two_rounds[1]).negative?
      if Board::ROUNDS.include?(last_two_rounds[1] + 1)
        last_two_rounds[1] + 1
      else
        last_two_rounds[1] - 1
      end
    elsif Board::ROUNDS.include?(last_two_rounds[1] - 1)
      last_two_rounds[1] - 1
    else
      last_two_rounds[1] + 1
    end
  end

  ##
  # Map the board as json
  # Only the last round will be mapped
  def json
    as_json(only: %i[status],
            include: { board_players: { only: %i[score player_id status] },
                       last_round: { only: %i[round_number status number_of_cards],
                                     include: { round_players: { only: %i[bet_wins bet_position current_wins player_id] },
                                                games: { only: %i[game_number status winner_id] } } } })
  end

  def complete_history_as_json
    as_json(only: %i[status],
            include: { board_players: { only: %i[score player_id status] },
                       rounds: { only: %i[round_number status number_of_cards],
                                 include: { round_players: { only: %i[cards bet_wins bet_position current_wins player_id] },
                                            games: { only: %i[game_number winner_id status],
                                                     include: { turns: { only: %i[card_played play_position player_id
                                                                                  player_position] } } } } } })
  end

  def join_board(player)
    raise 'Game Started' unless waiting_players?
    raise 'Player already joined' if player_in_board?(player)

    players.push(player)
  end

  def player_in_board?(player)
    players.include?(player)
  end

  def start_game
    raise 'Only one player joined. At least two players are required to start game.' if players.size <= 1

    self.status = :in_course

    # Player who goes first throwing cards
    self.first_player_id = board_players.first.player_id

    create_round
  end

  def create_round
    raise 'Previous rounds must finish before starting a new one' unless rounds.all?(&:finished?)

    card_number = next_round_number

    rounds.push(Round.create(board: self, number_of_cards: card_number, round_number: rounds.size))

    cards = deal_cards(players_ids.length, card_number)

    rounds.last.start_bet_round order_player_ids, cards

    save
  end

  def order_player_ids
    arr = players_id_in_course
    arr.rotate(arr.find_index(first_player_id))
  end

  def next_round_number
    return 3 if rounds.empty?

    last_two_rounds = rounds.last(2).map!(&:number_of_cards)

    return 4 if last_two_rounds.size == 1

    Board.next_round_from_last_two_played last_two_rounds
  end

  def players_id_in_course
    board_players.filter_map { |bp| bp.player_id unless bp.looser? }
  end

  def players_ids
    board_players.map(&:player_id)
  end

  def deal_cards(players, card_number)
    cards = []

    players.times do
      player_cards = deck.first(card_number)

      deck.rotate!(card_number)

      cards.push(player_cards)
    end

    cards
  end

  def player_bet_win(player_id, win_number)
    raise 'Game is not started' if waiting_players?

    rounds.last.bet_win player_id, win_number
  end

  def throw_card(player_id, card)
    rounds.last.throw_card player_id, card

    # if the round finish the scores must be updated
    finish_round if rounds.last.finished?
  end

  def finish_round
    rounds.last.players_ids_and_lost_number.each do |ob|
      board_players.find { |bp| bp.player_id == ob[:id] }.update_score ob[:lost]
    end

    check_end_game

    return if finished?

    update_first_player
    create_round
  end

  def update_first_player
    players_in_game = players_id_in_course
    players_in_board = players_ids

    players_in_board.rotate!(players_in_board.find_index(first_player_id))

    index = players_in_board.find_index(first_player_id) + 1

    index += 1 until players_in_game.any?(players_in_board[index])

    next_player_id = players_in_board[index]

    self.first_player_id = next_player_id if next_player_id.present?
  end

  def check_end_game
    number_of_loosers = board_players.select(&:looser?).size

    if number_of_loosers == board_players.size - 1
      # there is one winner
      board_player = board_players.find { |ob| ob.status.nil? }
      board_player.update(status: :winner)
      end_game
    end

    # all players lost
    end_game if number_of_loosers == board_players.size
  end

  def end_game
    self.status = :finished
  end

  def player_cards(player_id)
    rounds.last.player_cards(player_id)
  end

  private

  def set_token
    self.token = SecureRandom.base58
  end

  def create_deck
    card_deck = []

    ['-Or', '-Ba', '-Es', '-Co'].each do |i|
      (1..12).each do |j|
        card_deck.push(j.to_s + i)
      end
    end

    self.deck = card_deck.shuffle
  end
end
