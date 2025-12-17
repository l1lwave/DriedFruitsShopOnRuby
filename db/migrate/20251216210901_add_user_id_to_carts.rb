# db/migrate/*_add_user_id_to_carts.rb
class AddUserIdToCarts < ActiveRecord::Migration[8.0]
  def change
    add_reference :carts, :user, null: false, foreign_key: true
  end
end
