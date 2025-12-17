class AddDetailsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :full_name, :string
    add_column :orders, :phone, :string
    add_column :orders, :delivery_method, :string
    add_column :orders, :city, :string
    add_column :orders, :post_office_number, :string
    add_column :orders, :comment, :text
    add_column :orders, :payment_method, :string
  end
end
