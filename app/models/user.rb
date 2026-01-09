class User < ApplicationRecord
  # has_secure_password giúp tự động mã hóa mật khẩu bằng thư viện bcrypt.
  # user table phải có cột password_digest để lưu trữ mật khẩu đã mã hóa.
  # Nó cũng tự động thêm xác thực 'password' và 'password_confirmation' (nếu muốn).
  has_secure_password
  has_many :refresh_tokens, dependent: :delete_all


  # %w: shorthand để tạo ra một mảng (Array) gồm các chuỗi (Strings) mà không cần phải gõ dấu ngoặc kép hay dấu phẩy thủ công.
  # .freeze giúp mảng này không bị thay đổi trong suốt vòng đời ứng dụng.
  ROLES = %w[user admin].freeze
  ALPHABET_SORT_COLUMNS = %w[full_name email].freeze
  SORT_DIRECTIONS = %w[asc desc].freeze

  # Xác thực email: Phải tồn tại (presence) và không được trùng (uniqueness).
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # Lambda trong điều kiện xác thực password_digest chỉ áp dụng khi password được cung cấp.
  validates :password, length: { minimum: 6, maximum: 100 }, if: -> { password.present? }

  # Validate role phải nằm trong danh sách
  validates :role, inclusion: { in: ROLES }

  # Tự động chuyển email về chữ thường trước khi lưu vào database
  before_save :downcase_email

  # Tự động gán role là customer nếu lúc tạo mới chưa có role
  after_initialize :set_default_role, if: :new_record?

  # Scope lấy danh sách user CHƯA bị xóa
  scope :active, -> { where(deleted_at: nil) }

  # Scope lấy danh sách user ĐÃ bị xóa
  scope :deleted, -> { where.not(deleted_at: nil) }

  # Scope search index sử dụng trigram
  scope :search, -> (query) {
    rel = all
    return rel if query.blank?
    # sanitize_sql_like:  xác định một chuỗi ký tự có khớp với mẫu được chỉ định hay không
    where(
      "users.full_name ILIKE :q OR users.email ILIKE :q OR users.phone ILIKE :q",
      q: "%#{sanitize_sql_like(query)}%"
    )
  }

  # Scope filter theo ngày
  scope :filter_by_created_at, ->(from_date,to_date){
    rel = all

    if from_date.present?
      from = Date.parse(from_date).beginning_of_day
      rel = rel.where("created_at >= ?", from)
    end

    if to_date.present?
      to = Date.parse(to_date).end_of_day
      rel = rel.where("created_at <= ?", to)
    end

    rel
  }


  # Scope sort A-Z, Z-A
  scope :sort_alphabet, ->(column, direction){
    rel = all
    return rel if column.blank?

    column = ALPHABET_SORT_COLUMNS.include?(column) ? column : "full_name"
    direction = SORT_DIRECTIONS.include?(direction) ? direction : "asc"

    rel.order(column => direction)
  }

  # Đánh dấu user là đã xóa (soft delete)
  # Không xóa record khỏi DB
  def soft_delete!
    update!(deleted_at: Time.current)
  end

  # Khôi phục user đã bị soft delete
  def restore!
    update!(deleted_at: nil)
  end

  def deleted?
    deleted_at.present?
  end

  private
  def set_default_role
    self.role ||= "user"
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
