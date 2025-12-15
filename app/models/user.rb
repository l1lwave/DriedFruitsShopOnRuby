class User < ApplicationRecord
  has_secure_password
  has_many :orders, dependent: :nullify

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, inclusion: { in: %w[customer admin] }

  def admin?
    role == "admin"
  end
end
