class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.string :payment_method
      t.string :status
      t.string :transaction_id
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
