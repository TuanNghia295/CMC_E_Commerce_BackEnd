class Api::V1::Admin::UsersQuery
  def initialize(params = {})
    @params = params
  end

  # Đang sử dụng chain. Kết quả trả về của phương thức trước sẽ là đối tượng thực thi cho phương thức tiếp theo.
  def call
    User
      .where.not("LOWER(role) = ?", "admin")
      .search(@params[:q])
      .filter_by_created_at(@params[:from_date], @params[:to_date])
      .sort_alphabet(@params[:sort_by], @params[:sort_dir])
      .page(page)
      .per(per_page)
  end

  private

  def page
    (@params[:page] || 1).to_i
  end

  def per_page
    (@params[:per_page] || 10).to_i
  end
end
