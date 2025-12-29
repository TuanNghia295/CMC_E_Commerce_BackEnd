class RenameRefershTokenToRefreshTokens < ActiveRecord::Migration[8.1]
  def change
    rename_table :refresh_tokens, :refresh_tokens
  end
end
