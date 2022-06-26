class ApplicationController < ActionController::Base
  rescue_from RuntimeError, with: :handle_error

  skip_before_action :verify_authenticity_token

  def render_error_response(content, message = 'Unexpected Error', status = 400)
    render status:, json: { status:, success: false, message:, content: }
  end

  def render_success_response(content, message = 'Action completed successfully', status = 200)
    render status:, json: { status:, success: true, message:, content: }
  end

  def handle_error(error)
    render_error_response({}, error)
  end
end
