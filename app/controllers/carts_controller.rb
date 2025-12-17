class CartsController < ApplicationController
  before_action :require_login
  before_action :set_user_cart

  def show
    @cart = @user_cart
  end

  def destroy
    @user_cart.destroy if @user_cart
    redirect_to root_path, notice: "Кошик успішно очищено."
  end

  private

  def set_user_cart
    @user_cart = current_user.cart || current_user.create_cart
  end
end
