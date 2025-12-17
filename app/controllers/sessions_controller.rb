class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      merge_carts(user)

      redirect_to root_path, notice: "Ви успішно увійшли!"
    else
      flash.now[:alert] = "Невірний email або пароль."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logged_out_user_id = session[:user_id]

    reset_session

    flash[:notice] = "Ви успішно вийшли з системи."

    redirect_to root_path, status: :see_other
  end

  private

  def merge_carts(user)
    guest_cart = Cart.find_by(id: session[:cart_id])
    user_cart = user.cart

    if guest_cart
      if user_cart
        guest_cart.line_items.each do |guest_item|
          existing_item = user_cart.line_items.find_by(product: guest_item.product)

          if existing_item
            # Якщо товар вже є, оновлюємо кількість
            existing_item.quantity += guest_item.quantity
            existing_item.save
          else
            # Якщо товару немає, переносимо його до кошика користувача
            guest_item.update(cart_id: user_cart.id)
          end
        end
        # Знищуємо кошик гостя
        guest_cart.destroy

      else # 2. Передача: Кошик Гостя стає Кошиком Користувача
        guest_cart.update(user: user)
        user_cart = guest_cart
      end

      session[:cart_id] = user_cart.id

    elsif user_cart # 3. Кошик Гостя порожній, просто використовуємо кошик користувача
        session[:cart_id] = user_cart.id
    end
  end
end
