class Api::V1::Admin::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [ :login, :refresh ]

  # POST /api/v1/admin/auth/login
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password]) && user.role == "admin"
      access_token = JwtService.encode({ user_id: user.id, role: user.role })

      # tạo refresh token nếu chưa có hoặc lấy token hiện tại
      refresh_token_record = user.refresh_tokens.active.first_or_create!(
        token: SecureRandom.hex(32),
        expires_at: 30.days.from_now
      )

      render json: {
        access_token: access_token,
        refresh_token: refresh_token_record.token,
        user: user_response(user)
      }
    else
      render json: { error: "Invalid email, password or not admin" }, status: :unauthorized
    end
  end

  # POST /api/v1/admin/auth/refresh
  def refresh
    token_str = params[:refresh_token]

    if token_str.blank?
      return render json: { error: "No refresh token provided" }, status: :unauthorized
    end

    refresh_token = RefreshToken.active.find_by(token: token_str)

    if refresh_token.nil? || refresh_token.user.role != "admin"
      return render json: { error: "Invalid or expired refresh token" }, status: :unauthorized
    end

    user = refresh_token.user
    access_token = JwtService.encode({ user_id: user.id, role: user.role })

    render json: { access_token: access_token }
  end

  # POST /api/v1/admin/auth/logout
  def logout
    token_str = params[:refresh_token]

    if token_str.present?
      token = RefreshToken.find_by(token: token_str)
      token&.update!(revoked_at: Time.current)
    end

    render json: { message: "Logged out successfully" }
  end

  private

  def user_response(user)
    {
      id: user.id,
      email: user.email,
      full_name: user.full_name,
      role: user.role
    }
  end
end
