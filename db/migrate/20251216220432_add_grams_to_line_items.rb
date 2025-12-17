class AddGramsToLineItems < ActiveRecord::Migration[8.0]
  def change
    add_column :line_items, :grams, :integer
  end
end
