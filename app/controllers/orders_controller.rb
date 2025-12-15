class OrdersController < ApplicationController
  before_action :require_login

  def index
    # просмотр заказов текущего пользователя
    @orders = current_user.orders.includes(:product).order(created_at: :desc)
  end

  def new
    if params[:product_id]
      @product = Product.find(params[:product_id])
      @order = Order.new(product: @product, product_count: 1)
    else
      @order = Order.new
      @products = Product.all
    end
  end

  def create
    @order = current_user.orders.new(order_params)
    if @order.save
      redirect_to products_path, notice: "Замовлення оформлено!"
    else
      @products = Product.all
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:product_id, :product_count, :address, :status)
  end
end
