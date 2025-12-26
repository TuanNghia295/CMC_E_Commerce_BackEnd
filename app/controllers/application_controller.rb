class ApplicationController < ActionController::API
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  # stale_when_importmap_changes

  before_action :authenticate_request

  attr_reader :current_user

  private
  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    decoded = JwtService.decode(token)
    @current_user = User.find(decoded[:user_id]) if decoded
  rescue
      render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
