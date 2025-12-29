class AuthController < ApplicationController
  # skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_request, only: [ :register, :login ]
  # Bỏ qua xác thực cho các action đăng ký và đăng nhập
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      access_token = JwtService.encode({
        user_id: user.id
        # role: user.role
      })

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

      render json: {
        access_token: accessToken,
        refresh_token: refreshToken,
        user: user_response(user)
      }
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private
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
