class CallbackRequest < ApplicationRecord
  validates :phone_number, presence: true, format: { with: /\A\+?[\d\s-]{9,}\z/, message: "невірний формат" }
end
