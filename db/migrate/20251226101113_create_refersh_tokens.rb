class CreateRefershTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :refresh_tokens do |t|
      t.string :token
      t.timestamp :expires_at
      t.timestamp :revoked_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
