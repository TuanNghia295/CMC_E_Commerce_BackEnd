class Api::V1::Admin::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:login]

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password]) && user.role == "admin"
      access_token = JwtService.encode({ user_id: user.id, role: user.role })
      refresh_token_record = user.refresh_tokens.create!(
        token: SecureRandom.hex(32),
        expires_at: 30.days.from_now
      )
      set_admin_refresh_token_cookie(refresh_token_record.token)
      render json: {
        access_token: access_token,
        user: user_response(user)
      }
    else
      render json: { error: "Invalid email, password or not admin" }, status: :unauthorized
    end
  end

  def logout
    token_str = cookies.signed[:admin_refresh_token]
    token = RefreshToken.find_by(token: token_str)
    if token
      token.update!(revoked_at: Time.current)
      cookies.delete(:admin_refresh_token, path: "/api/v1/admin/auth", secure: Rails.env.production?)
      render json: { message: "Logged out successfully" }
    else
      cookies.delete(:admin_refresh_token, path: "/api/v1/admin/auth", secure: Rails.env.production?)
      render json: { error: "Token not found" }, status: :not_found
    end
  end

  private

  def set_admin_refresh_token_cookie(token)
    cookies.signed[:admin_refresh_token] = {
      value: token,
      httponly: true,
      expires: 30.days.from_now,
      path: "/api/v1/admin/auth",
      same_site: :none,
      secure: Rails.env.production?
    }
  end

  def user_response(user)
    {
      id: user.id,
      email: user.email,
      full_name: user.full_name,
      role: user.role
    }
  end
end
