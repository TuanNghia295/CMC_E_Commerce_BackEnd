class CreateRefreshTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :refresh_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token
      t.timestamp :expires_at
      t.timestamp :revoked_at

      t.timestamps
    end
  end
end
