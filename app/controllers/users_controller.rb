class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # по умолчанию роль customer
    @user.role = "customer"
    if @user.save
      session[:user_id] = @user.id
      redirect_to products_path, notice: "Реєстрація успішна!"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
