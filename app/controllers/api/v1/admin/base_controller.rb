class Api::V1::Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    decoded = JwtService.decode(token)
    user = User.find(decoded[:user_id]) if decoded
    unless user&.role == "admin"
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  rescue
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
