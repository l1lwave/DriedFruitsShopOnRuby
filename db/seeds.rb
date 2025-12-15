# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# create admin
User.create!(email: "admin@example.com", name: "Admin", password: "password", password_confirmation: "password", role: "admin")

# create sample products
Product.create!(name: "Курага", price: 120.0, description: "Смачна курага, відбірна.", image_url: "", category: "Курага")
Product.create!(name: "Родзинки", price: 95.0, description: "Солодкі родзинки.", image_url: "", category: "Родзинки")
Product.create!(name: "Фініки", price: 200.0, description: "Стиглі фініки.", image_url: "", category: "Фініки")
