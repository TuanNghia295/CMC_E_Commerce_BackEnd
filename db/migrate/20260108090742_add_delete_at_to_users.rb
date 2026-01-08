class AddDeleteAtToUsers < ActiveRecord::Migration[8.1]
  def change
    # Chỉ thêm cột nếu chưa có
    unless column_exists?(:users, :deleted_at)
      add_column :users, :deleted_at, :datetime
    end

    # Thêm index nếu chưa có
    unless index_exists?(:users, :deleted_at)
      add_index :users, :deleted_at
    end
  end
end
