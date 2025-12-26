class CreateShipments < ActiveRecord::Migration[8.1]
  def change
    create_table :shipments do |t|
      t.string :status
      t.string :tracking_number
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
