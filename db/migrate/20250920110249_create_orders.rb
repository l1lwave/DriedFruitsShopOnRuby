class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :product_count, default: 1
      t.text :address
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
