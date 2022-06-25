class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def render_error_response(content, message = 'Unexpected Error', status = 400)
    render status:, json: { status:, success: false, message:, content: }
  end

  def render_success_response(content, message = 'Action completed successfully', status = 200)
    render status:, json: { status:, success: true, message:, content: }
  end
end
