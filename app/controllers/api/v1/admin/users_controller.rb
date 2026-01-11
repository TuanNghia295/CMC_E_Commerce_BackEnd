class Api::V1::Admin::UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]

  # @instance variable cho phép tái sử dụng kết quả tìm kiếm mà không cần phải truy vấn database lần nữa.
  def show
    render json: @user, status: :ok
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: { user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: { user: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.soft_delete!
    render json: { message: "User deleted successfully" }, status: :ok
  end

  def index
    users = Api::V1::Admin::UsersQuery.new(params).call
    render json: {
      data: users,
      meta: {
        page: users.current_page,
        per_page: users.limit_value,
        total_count: users.total_count,
        total_pages: users.total_pages
      }
    }
  end


  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: "User not found" }, status: :not_found
  end

  def user_params
    params.require(:user).permit(
      :email,
      :full_name,
      :phone,
      :password,
      :password_confirmation,
      :role
    )
  end
end
