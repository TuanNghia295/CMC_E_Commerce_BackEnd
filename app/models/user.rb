class User < ApplicationRecord
  # has_secure_password giúp tự động mã hóa mật khẩu bằng thư viện bcrypt.
  # user table phải có cột password_digest để lưu trữ mật khẩu đã mã hóa.
  # Nó cũng tự động thêm xác thực 'password' và 'password_confirmation' (nếu muốn).
  has_secure_password

  # %w[user admin] tạo ra mảng ["user", "admin"].
  # .freeze giúp mảng này không bị thay đổi trong suốt vòng đời ứng dụng.
  ROLES = %w[user admin].freeze

  # Xác thực email: Phải tồn tại (presence) và không được trùng (uniqueness).
  validates :email, presence: true, uniqueness: true
  # Lambda trong điều kiện xác thực password_digest chỉ áp dụng khi password được cung cấp.
  validates :password, length: { minimum: 6, maximum: 100 }, if: -> { password.present? }
  validates :role, inclusion: { in: ROLES }

  # Soft Delete: Lọc người dùng chưa bị xóa (deleted_at là nil).
  scope :active, -> { where(deleted_at: nil) }
end
