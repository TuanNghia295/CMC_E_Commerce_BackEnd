class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [ :register, :login ]

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      access_token = JwtService.encode({
        user_id: user.id
      })

      # create new refresh token everytime user login
      refresh_token_record = user.refresh_tokens.create!(
        token: SecureRandom.hex(32),
        expires_at: 30.days.from_now
      )

      # save the rf token to cookie
      set_refresh_token_cookie(refresh_token_record.token)

      render json: {
        access_token: access_token,
        user: user_response(user)
      }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def register
    user = User.new(register_params)
    if user.save
      accessToken = JwtService.encode({ user_id: user.id })
      refreshToken = user.refresh_tokens.create!(
        token: SecureRandom.hex(32),
        expires_at: 30.days.from_now
      )

      set_refresh_token_cookie(refreshToken.token)

      render json: {
        access_token: accessToken,
        user: user_response(user)
      }
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def logout
    # Chỉ lấy refresh token từ cookies.signed (giải mã), không nhận từ header/body
    token_str = cookies.signed[:refresh_token]
    token = nil

    Rails.logger.info "[LOGOUT] Refresh token (from cookie): #{token_str}"

    if token_str.present?
      token = RefreshToken.find_by(token: token_str)
    end

    if token
      token.update!(revoked_at: Time.current)
      cookies.delete(:refresh_token, path: "/api/v1/auth", secure: Rails.env.production?)
      render json: { message: "Logged out successfully" }
    else
      cookies.delete(:refresh_token, path: "/api/v1/auth", secure: Rails.env.production?)
      render json: { error: "Token not found" }, status: :not_found
    end
  end

  private
  def set_refresh_token_cookie(token)
    cookies.signed[:refresh_token] = {
      value: token,
      httponly: true,
      expires: 30.days.from_now,
      path: "/api/v1/auth", # only sent cookies for routes auth/token
      same_site: :none,
      secure: Rails.env.production? # only sent by HTTPS in production env
    }
  end


  def register_params
    params.permit(:email, :password, :password_confirmation, :full_name,)
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
