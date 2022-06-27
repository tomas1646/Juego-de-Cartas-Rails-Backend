class BoardsController < ApplicationController
  before_action :set_board, except: %i[index create]
  before_action :check_token, except: %i[show]

  def index
    boards = Board.ransack(players_id_eq: params[:player] ? @player.id : nil,
                           status_in: params[:status]).result.includes(:players)

    render_success_response(boards.preload(:players).map(&:json))
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
    return render_success_response(@board.json, 'Joined to the board') if @board.player_in_board? @player

    @board.join_board @player

    if @board.save
      render_success_response(@board.json, 'Joined to the board')
    else
      render_error_response({}, "Error Joining Board #{board.errors.full_messages.join(', ')}")
    end
  end

  def start_game
    @board.start_game

    if @board.save
      render_success_response(@board.json, 'Game Started')
    else
      render_error_response({}, "Error Starting Game #{board.errors.full_messages.join(', ')}")
    end
  end

  def bet_wins
    @board.player_bet_win @player, params[:wins]

    if @board.save
      render_success_response(@board.json, 'Win Number Set')
    else
      render_error_response({}, "Error setting win number #{board.errors.full_messages.join(', ')}")
    end
  end

  def throw_card
    @board.throw_card @player, params[:card]

    if @board.save
      render_success_response(@board.json, 'Card Thrown')
    else
      render_error_response({}, "Error Throwing Card #{board.errors.full_messages.join(', ')}")
    end
  end

  def cards
    render_success_response(@board.player_cards(@player.id))
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
