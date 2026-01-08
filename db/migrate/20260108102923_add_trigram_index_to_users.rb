
# db/migrate/20260108100000_add_trigram_index_to_users.rb
class AddTrigramIndexToUsers < ActiveRecord::Migration[8.1]
  def change
    add_index :users, :full_name,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "index_users_on_full_name_trgm"


    add_index :users, :email,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "index_users_on_email_trgm"
  end
end
