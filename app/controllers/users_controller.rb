class UsersController < ApplicationController
  # 🌟 Примітка: Використовуємо :set_user для всіх дій, які працюють з конкретним користувачем
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  # 1. Забезпечує, що користувач авторизований для всіх дій
  before_action :require_login, only: [ :edit, :update, :destroy ]

  # 2. Перевіряє права: тільки власник або адміністратор може редагувати/видаляти
  before_action :require_same_user_or_admin, only: [ :edit, :update, :destroy ]

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    # Встановлюємо роль за замовчуванням
    @user.role = "customer"

    if @user.save
      session[:user_id] = @user.id
      redirect_to products_path, notice: "Реєстрація успішна! Ласкаво просимо до DriedFruitsShop."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /users/:id/edit
  def edit
    # @user встановлено через set_user
  end

  # PATCH/PUT /users/:id
  def update
    # Note: user_params включає password/password_confirmation.
    # Модель повинна їх ігнорувати, якщо вони порожні.
    if @user.update(user_params)
      redirect_to root_path, notice: "Ваш профіль успішно оновлено!"
    else
      flash.now[:alert] = "Не вдалося оновити профіль. Перевірте помилки нижче."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    # @user встановлено через set_user
    @user.destroy

    if @user == current_user
      # Якщо користувач видалив сам себе
      session[:user_id] = nil
      redirect_to root_path, notice: "Ваш обліковий запис було успішно видалено."
    else
      # Якщо адміністратор видаляє іншого користувача
      redirect_to users_path, notice: "Користувача '#{@user.name}' успішно видалено адміністратором."
    end
  end

  # GET /users/:id
  def show
    # Можна залишити порожнім, якщо сторінка show є
  end


  private

  # 🌟 ВИПРАВЛЕНИЙ set_user: Використовує ID з параметрів
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Користувача не знайдено."
  end

  # Допоміжний метод: Перевіряє, чи користувач є власником або адміністратором
  def require_same_user_or_admin
    # Припускаємо, що current_user та метод admin? доступні
    unless current_user == @user || (logged_in? && current_user.admin?)
      redirect_to root_path, alert: "Ви можете редагувати або видаляти лише власний профіль."
    end
  end

  # Використовуйте цей метод у вашому ApplicationController (якщо його там немає)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user
  def logged_in?
    !!current_user
  end
  helper_method :logged_in?
  def require_login
    unless logged_in?
      redirect_to login_url, alert: "Ви маєте увійти для доступу до цієї сторінки."
    end
  end


  # Сильні параметри
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
