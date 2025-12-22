class CreateShipments < ActiveRecord::Migration[8.1]
  def change
    create_table :shipments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :status
      t.string :tracking_number

      t.timestamps
    end
  end
end
