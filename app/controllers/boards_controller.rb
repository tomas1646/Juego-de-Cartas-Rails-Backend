class BoardsController < ApplicationController
  before_action :set_board, except: %i[index create]
  before_action :check_token, except: %i[show]

  def index
    boards = Board.ransack(players_id_eq: params[:player] ? @player.id : nil,
                           status_in: params[:status]).result.includes(:players)

    render_success_response(boards.preload(:players).map { |board| board.json })
  end

  def show
    render_success_response(@board.json)
  end

  def create
    board = Board.new
    board.join_board @player
    if board.save
      render_success_response(board.json, 'Board Created')
    else
      render_error_response({}, "Error creating Board #{board.errors.full_messages.join(', ')}")
    end
  end

  def join
    return render_success_response(@board.json, 'Joined to the board') if @board.is_player_in_board @player

    return render_error_response({}, 'Game Started. Cant join.') unless @board.waiting_players?

    @board.join_board @player

    if @board.save
      render_success_response(@board.json, 'Joined to the board')
    else
      render_error_response({}, "Error Joining Board #{board.errors.full_messages.join(', ')}")
    end
  end

  def start_game
    return render_error_response({}, 'There is only one player. Cant start game.') if @board.players.length == 1

    @board.start_game

    if @board.save
      render_success_response(@board.json, 'Game Started')
    else
      render_error_response({}, "Error Starting Game #{board.errors.full_messages.join(', ')}")
    end
  end

  def start_card_round
    return render_error_response({}, "Board isn't waiting for wins") unless @board.waiting_wins_asked?

    @board.status = :waiting_card_throw

    if @board.save
      render_success_response(@board.json, 'Board status change to Waiting Card Throw')
    else
      render_error_response({}, "Error Starting Game #{board.errors.full_messages.join(', ')}")
    end
  end

  def end_card_round
    return render_error_response({}, "Board isn't waiting cards") unless @board.waiting_card_throw?

    @board.finish_round params[:round_card_number].to_i

    if @board.save
      render_success_response(@board.json, 'Round Finished')
    else
      render_error_response({}, "Error Finishing Round #{board.errors.full_messages.join(', ')}")
    end
  end

  def update_score
    return render_error_response({}, 'Only player 1 can change scores') if @player != @board.players[0]

    @board.score = params[:scores].to_json

    if @board.save
      render_success_response(@board.json, 'Scores Updated')
    else
      render_error_response({}, "Error Updating Scores #{board.errors.full_messages.join(', ')}")
    end
  end

  def throw_card
    return render_error_response({}, 'Cant throw two cards') if @board.did_player_throw_card? @player

    @board.throw_card @player, params[:card]

    if @board.save
      render_success_response(@board.json, 'Card Thrown')
    else
      render_error_response({}, "Error Throwing Card #{board.errors.full_messages.join(', ')}")
    end
  end

  def cards
    render_success_response(@board.get_player_cards(@player))
  end

  def set_wins
    @board.set_player_win @player, params[:wins]

    if @board.save
      render_success_response(@board.json, 'Win Number Set')
    else
      render_error_response({}, "Error setting win number #{board.errors.full_messages.join(', ')}")
    end
  end

  def end_game
    @board.end_game params[:winner]

    if @board.save
      render_success_response(@board.json, 'Game Finished')
    else
      render_error_response({}, "Error finishing game #{board.errors.full_messages.join(', ')}")
    end
  end

  private

  def set_board
    @board = Board.find_by(token: params[:id])
    return if @board.present?

    render_error_response({}, "Board doesn't exists", 404)
  end

  def check_token
    @player = Player.find_by(token: request.headers['Authorization'])
    return if @player.present?

    render_error_response({}, "Player with token #{request.headers['Authorization']} doesn't exists", 404)
  end
end
