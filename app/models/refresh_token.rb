class RefreshToken < ApplicationRecord
  belongs_to :user

  # lấy danh sách tất cả các token còn dùng được
  scope :active, -> {
    where(revoked_at: nil).where("expires_at > ?", Time.current)
  }
end
