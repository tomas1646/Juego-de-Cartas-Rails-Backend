class PlayersController < ApplicationController
  before_action :check_token, only: %i[update update_picture]

  def create
    player = Player.new(user_params)

    if player.save
      render_success_response(player.json, 'Player Created')
    else
      render_error_response({}, "Error creating Player #{player.errors.full_messages.join(', ')}")
    end
  end

  def update
    @player.assign_attributes(user_params)

    if @player.save
      render_success_response(@player.json, 'Player Updated')
    else
      render_error_response({}, "Error updating Player #{@player.errors.full_messages.join(', ')}")
    end
  end

  def update_picture
    @player.avatar.purge if @player.avatar.attached?

    @player.avatar.attach(params[:avatar])

    if @player.save
      render_success_response(@player.json, 'Picture Updated')
    else
      render_error_response({}, "Error updating Picture #{@player.errors.full_messages.join(', ')}")
    end
  end

  def login
    player = Player.find_by(user_name: params[:user_name])

    if player.blank? || player.password != params[:password]
      render_error_response({}, 'Incorrect Playername or Password')
    else
      render_success_response(player.json, 'Login successful')
    end
  end

  private

  def user_params
    params.require(:player).permit(:name, :password, :user_name)
  end

  def check_token
    @player = Player.find_by(token: request.headers['Authorization'])
    return if @player.present?

    render_error_response({}, "Player with token #{request.headers['Authorization']} doesn't exists", 404)
  end
end
