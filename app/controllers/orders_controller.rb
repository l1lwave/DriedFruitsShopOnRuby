class OrdersController < ApplicationController
  before_action :require_login

  def new
    @cart = current_user.cart
    if @cart.nil? || @cart.line_items.empty?
      redirect_to products_path, alert: "Кошик порожній, неможливо оформити замовлення."
      return
    end
    @order = Order.new(user: current_user)
  end

  def create
    @cart = current_user.cart

    # Створюємо об'єкт замовлення, але ще не зберігаємо в БД
    @order = current_user.orders.new(order_params)
    @order.total_price = @cart.total_price

    # Використовуємо транзакцію для всієї операції
    Order.transaction do
      if @order.save
        # Переносимо товари
        @cart.line_items.each do |item|
          # Використовуємо update_column, щоб обійти валідації, якщо вони заважають,
          # або звичайний update!, якщо ми впевнені в моделі LineItem
          item.update!(order_id: @order.id, cart_id: nil)
        end

        # Очищуємо кошик (важливо видалити ТІЛЬКИ зв'язок або сам кошик,
        # переконавшись, що товари вже мають order_id)
        @cart.destroy!

        # Якщо все пройшло успішно, редирект
        if @order.payment_method == "card"
          redirect_to products_path, notice: "Замовлення №#{@order.id} успішно оплачено карткою! Дякуємо за покупку."
        else
          redirect_to products_path, notice: "Замовлення №#{@order.id} прийнято! Ми зателефонуємо вам для підтвердження."
        end
      else
        # Якщо замовлення не валідне (наприклад, не вказана адреса)
        flash.now[:alert] = "Будь ласка, заповніть усі необхідні поля: #{@order.errors.full_messages.to_sentence}"
        render :new, status: :unprocessable_entity
        # Викликаємо rollback, щоб не створювати пусте замовлення у випадку помилок
        raise ActiveRecord::Rollback
      end
    end
  end

  def index
    @orders = current_user.orders.includes(line_items: :product).order(created_at: :desc)
  end

  private

  def order_params
  params.require(:order).permit(
    :address,
    :full_name,
    :phone,
    :delivery_method,
    :city,
    :post_office_number,
    :comment,
    :payment_method
  )
  end
end
