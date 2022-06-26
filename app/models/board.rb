class Board < ApplicationRecord # rubocop:disable Metrics/ClassLength
  POINTS = :CALERA
  ROUNDS = [1, 2, 3, 4, 5].freeze

  before_create :create_deck, :set_token

  has_many :board_players
  has_many :rounds
  has_many :players, through: :board_players

  enum status: { waiting_players: 0, in_course: 1, finished: 2 }

  def self.winner_card(cards_position) # rubocop:disable Metrics/AbcSize
    # cards_position is an array with ["card", position] example [["1-Or", 0], ["12-Co", 1]]
    # map card (from string to integer) integer value ex [[1, 0], [12, 1]]
    arr = cards_position.map { |cp| [cp[0].split('-')[0].to_i, cp[1]] }

    # get the maximum value
    max = arr.max_by { |it| it[0] }

    # get the cards with the max value
    winner_cards = arr.select { |ob| ob[0] == max[0] }

    # check if there is only one card with the max value
    winner_position = if winner_cards.size == 1
                        # only one card with the max value
                        winner_cards[0][1]
                      else
                        # if there is two cards with the max value, this search the one that was played first
                        winner_cards.min_by { |it| it[1] }[1]
                      end

    cards_position.find { |ob| ob[1] == winner_position }
  end

  def self.next_round_card_number(last_two_rounds)
    return 4 if last_two_rounds.size == 1

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

  def json
    as_json(only: %i[status],
            include: { board_players: { only: %i[score player_id status] },
                       rounds: { only: %i[round_number status number_of_cards],
                                 include: { round_players: { only: %i[cards bet_wins bet_position current_wins player_id] },
                                            games: { only: %i[game_number winner_id], include: {
                                              turns: { only: %i[card_played play_position player_id player_position] }
                                            } } } } })
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
    self.next_first_player_id = board_players.first.player_id

    create_round
  end

  def create_round
    return unless rounds.all?(&:finished?)

    card_number = next_round_number
    round_created = Round.create(board: self, number_of_cards: card_number, round_number: rounds.size)

    rounds.push(round_created)

    players_ids = players_id_in_course
    ids_with_order = order_player_ids(players_ids)
    cards = deal_cards(players_ids.length, card_number)

    rounds.last.start_bet_round ids_with_order, cards

    save
  end

  def order_player_ids(players_ids)
    players_ids.rotate(players_ids.find_index(next_first_player_id))
  end

  def next_round_number
    return 3 if rounds.empty?

    last_two_rounds = rounds.last(2).map!(&:number_of_cards)

    Board.next_round_card_number last_two_rounds
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

  def bet_wins(player_id, win_number)
    raise 'Game is not started' if waiting_players?

    rounds.last.set_bet player_id, win_number
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

    players_in_board.rotate!(players_in_board.find_index(next_first_player_id))

    index = players_in_board.find_index(next_first_player_id) + 1

    index += 1 until players_in_game.any?(players_in_board[index])

    next_player_id = players_in_board[index]

    self.next_first_player_id = next_player_id if next_player_id.present?
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

  def get_player_cards(player)
    rounds.last.player_cards(player.id)
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
