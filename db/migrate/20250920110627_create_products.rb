class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.decimal :price, precision: 8, scale: 2, default: 0
      t.text :description
      t.string :image_url
      t.string :category

      t.timestamps
    end
  end
end
