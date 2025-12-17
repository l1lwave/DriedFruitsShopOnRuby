class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :body, length: { maximum: 500 }
  validates :user_id, uniqueness: { scope: :product_id, message: "Ви вже залишили відгук про цей продукт" }
end
