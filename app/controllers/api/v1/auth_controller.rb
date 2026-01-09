class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [ :register, :login, :refresh ]

  # POST /api/v1/auth/login
  def login
    user = User.active.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      access_token = JwtService.encode({ user_id: user.id })

      # check if user already has a valid refresh token
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
      render json: { message: "Invalid email or password" }, status: :unauthorized
    end
  end

  # POST /api/v1/auth/register
  def register
    user = User.new(register_params)
    if user.save
      access_token = JwtService.encode({ user_id: user.id })

      refresh_token = user.refresh_tokens.create!(
        token: SecureRandom.hex(32),
        expires_at: 30.days.from_now
      )

      render json: {
        access_token: access_token,
        refresh_token: refresh_token.token,
        user: user_response(user)
      }
    else
      render json: { message: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/auth/refresh
  def refresh
    token_str = params[:refresh_token]

    if token_str.blank?
      return render json: { error: "No refresh token provided" }, status: :unauthorized
    end

    refresh_token = RefreshToken.active.find_by(token: token_str)

    if refresh_token.nil?
      return render json: { error: "Invalid or expired refresh token" }, status: :unauthorized
    end

    user = refresh_token.user
    access_token = JwtService.encode({ user_id: user.id })

    render json: { access_token: access_token }
  end

  # POST /api/v1/auth/logout
  def logout
    token_str = params[:refresh_token]

    if token_str.present?
      token = RefreshToken.find_by(token: token_str)
      token&.update!(revoked_at: Time.current)
    end

    render json: { message: "Logged out successfully" }
  end

  private

  # Form-data params
  def register_params
    params.permit(:email, :password, :password_confirmation, :full_name)
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
