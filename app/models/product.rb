class Product < ApplicationRecord
  has_many :orders, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
