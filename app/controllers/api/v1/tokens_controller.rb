class Api::V1::TokensController < ApplicationController
  skip_before_action :authenticate_request, only: [ :refresh ]

  def refresh
    #  get token from cookies
    token_str = cookies.signed[:refresh_token]
    p "TOKEN #{token_str}"
    if token_str.blank?
      render_unauthorized and return
    end
    # find available old token
    old_token = RefreshToken.active.find_by(token: token_str)

    unless old_token
      render_unauthorized and return
    end
    # revoke old token immediately
    old_token.update!(revoked_at: Time.current)

    # create new token
    user = old_token.user
    new_access_token = JwtService.encode({ user_id: user.id, role: user.role })
    new_refresh_token = user.refresh_tokens.create!(
      token: SecureRandom.hex(32),
      expires_at: 30.days.from_now
    )

    # overwrite new cookies
    cookies.signed[:refresh_token] = {
      value: new_refresh_token.token,
      httponly: true,
      expires: 30.days.from_now,
      path: "/api/v1/auth"
    }

    render json: {
      access_token: new_access_token
    }, status: :ok
  end

  private

  def render_unauthorized
    render json: { error: "Invalid or expired refresh token" }, status: :unauthorized
  end
end
