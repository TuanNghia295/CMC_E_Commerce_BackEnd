class TokensController < ApplicationController
  # Bỏ qua xác thực cho action refresh
  skip_before_action :authenticate_request, only: [ :refresh ]

  def RefreshToken
    token = RefreshToken.active.find_by(token: params[:refresh_token])

    render_authorized unless token

    accessToken = JwtService.encode(user_id: token.user_id)

    render json: {
      access_token: accessToken
    }
  end

  private

  def render_authorized
    render json: {
      error: "Invalid refresh token"
    },
    status: :unauthorized
  end

  def logout
    token = RefreshToken.find_by(token: params[:refresh_token])
    token&.update(revoked_at: Time.current)

    render json: { message: "Logged out successfully" }
  end
end
