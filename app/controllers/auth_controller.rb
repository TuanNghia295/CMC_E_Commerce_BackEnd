class AuthController < ApplicationController
  # skip_before_action :verify_authenticity_token
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      access_token = JwtService.encode({
        user_id: user.id,
        role: user.role
      })

      render json: {
        access_token: access_token,
        user: {
          id: user.id,
          email: user.email,
          full_name: user.full_name,
          role: user.role
        }
      }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end
