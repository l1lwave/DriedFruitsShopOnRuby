class Cart < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :nullify
  has_many :products, through: :line_items

  def total_price
    line_items.sum { |item| item.quantity * item.price }
  end
end
