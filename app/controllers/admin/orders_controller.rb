class Admin::OrdersController < Admin::BaseController
  def index
    @orders = Order.includes(:user, line_items: :product).order(created_at: :desc)
  end

  def show
    @order = Order.find(params[:id])
    @line_items = @order.line_items.includes(:product)
  end

  def update_status
    @order = Order.find(params[:id])
    if @order.update(status: params[:status])
      redirect_to admin_order_path(@order), notice: "Статус оновлено."
    else
      redirect_to admin_order_path(@order), alert: "Помилка оновлення."
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to admin_orders_path, notice: "Замовлення видалено."
  end
end
