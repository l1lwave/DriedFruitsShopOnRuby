class Order < ApplicationRecord
  # Асоціації
  belongs_to :user
  has_many :line_items
  has_many :products, through: :line_items
  has_many :line_items, dependent: :destroy

  # 🌟 ВИПРАВЛЕНО: Новий синтаксис enum для Rails 7+ 🌟
  enum :status, {
    pending: "В обробці",
    paid: "Оплачено",
    shipped: "Відправлено",
    completed: "Завершено",
    cancelled: "Скасовано"
  }, default: :pending

  # Валідації
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :full_name, :phone, :delivery_method, :city, :payment_method, presence: true
  # Адреса або відділення валідуються залежно від способу доставки
  validates :address, presence: true, if: -> { delivery_method == "courier" }
  validates :post_office_number, presence: true, if: -> { delivery_method == "post" }
end
