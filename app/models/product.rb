class Product < ApplicationRecord
  belongs_to :category, optional: true

  # Зробіть це обов'язковим для форми:
  validates :category_id, presence: true

  has_many :line_items, dependent: :restrict_with_error

  has_many :reviews, dependent: :destroy

  has_many :line_items, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # Метод для розрахунку середнього рейтингу
  def average_rating
    reviews.average(:rating).to_f.round(1)
  end

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
