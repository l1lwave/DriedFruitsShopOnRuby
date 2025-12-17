class LineItemsController < ApplicationController
  before_action :require_login

  # POST /line_items
  def create
    product = Product.find(params[:product_id])
    @cart = current_user.cart || current_user.create_cart

    # Використовуємо :quantity_grams з форми, конвертуємо в integer
    requested_grams = params[:quantity_grams].to_i

    if requested_grams < 50
      redirect_to product_path(product), alert: "Мінімальна вага для замовлення 50 грамів." and return
    end

    # 1. Обчислюємо ціну за обрану вагу
    # Ціна товару (@product.price) встановлена за 100 грамів.
    price_per_gram = product.price / 100.0
    final_price = price_per_gram * (requested_grams / 100)

    # 2. Шукаємо існуючий LineItem
    # Якщо товар вже є, ми просто збільшуємо вагу і перераховуємо ціну.
    @line_item = @cart.line_items.find_by(product_id: product.id)

    if @line_item
      # Збільшуємо загальну вагу і перераховуємо загальну ціну
      @line_item.quantity += requested_grams # quantity тепер зберігає загальну вагу
      # Ціна LineItem тепер є загальною ціною за цю вагу
      @line_item.price = (@line_item.quantity / 100.0) * product.price
    else
      # Створюємо новий LineItem
      @line_item = @cart.line_items.build(
        product: product,
        quantity: requested_grams, # quantity тепер = початкова вага в грамах
        price: final_price # price = ціна за цю вагу
      )
    end

    if @line_item.save
      redirect_to cart_path(@cart), notice: "#{product.name} (додано #{requested_grams} г) успішно додано до кошика."
    else
      redirect_to products_path, alert: "Не вдалося додати товар до кошика."
    end
  end

  def destroy
    begin
      @line_item = LineItem.find(params[:id])
      cart = @line_item.cart
      unless cart.user == current_user
        redirect_to root_path, alert: "Доступ заборонено." and return
      end

      @line_item.destroy
      redirect_to cart_path(cart), notice: "Товар видалено з кошика."
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Позицію в кошику не знайдено."
    end
  end
end
