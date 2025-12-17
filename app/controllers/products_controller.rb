class ProductsController < ApplicationController
  # 1. Знаходить товар по ID для дій, що стосуються одного товару
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  # 2. Обмежує доступ до CRUD-дій лише для адміністраторів
  before_action :require_admin, only: [ :new, :create, :edit, :update, :destroy ]

  # 3. Створює категорію, якщо вказано, та оновлює params
  before_action :create_category_if_needed, only: [ :create, :update ]

  # GET /products
  def index
    # 1. Початковий запит: Всі товари
    @products = Product.all

    # 2. Фільтр за Категоріями
    if params[:category_ids].present?
      @products = @products.where(category_id: params[:category_ids])
    end

    # 3. Фільтр за Ціною (Діапазон)
    @products = @products.where("price >= ?", params[:min_price].to_f) if params[:min_price].present?
    @products = @products.where("price <= ?", params[:max_price].to_f) if params[:max_price].present?

    # 4. Сортування
    case params[:sort_by]
    when "price_asc"
      @products = @products.order(price: :asc)
    when "price_desc"
      @products = @products.order(price: :desc)
    when "newest"
      @products = @products.order(created_at: :desc)
    when "popular"
      # Тимчасово сортуємо за створенням, поки не буде логіки популярності
      @products = @products.order(created_at: :desc)
    else
      @products = @products.order(created_at: :desc)
    end

    # 5. Фінальна колекція (Включаємо категорії для оптимізації)
    @products = @products.includes(:category)
    @categories = Category.all
  end

  def show
    @product = Product.includes(reviews: :user).find(params[:id])
  end

  # GET /products/new
  def new
    @product = Product.new
    @categories = Category.all
  end

  # POST /products
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Товар успішно додано!"
    else
      @categories = Category.all
      render :new, status: :unprocessable_entity
    end
  end

  # GET /products/:id/edit
  def edit
    @categories = Category.all
  end

  # PATCH/PUT /products/:id
  def update
    if @product.update(product_params)
      redirect_to product_path(@product), notice: "Товар '#{@product.name}' успішно оновлено."
    else
      @categories = Category.all
      flash.now[:alert] = "Не вдалося оновити товар. Перевірте помилки."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/:id
  def destroy
    if @product.destroy
      redirect_to products_path, notice: "Товар '#{@product.name}' успішно видалено."
    else
      redirect_to product_path(@product), alert: "Не вдалося видалити товар."
    end
  rescue ActiveRecord::RecordNotDestroyed => e
    # Обробка винятків, якщо модель використовує restrict_with_error
    redirect_to product_path(@product), alert: "Помилка при видаленні: #{e.message}"
  end


  private

  # Встановлює @product
  def set_product
    @product = Product.find(params[:id])
  end

  # Забезпечує, що користувач є адміністратором
  def require_admin
    unless logged_in? && current_user.admin?
      redirect_to root_path, alert: "У вас немає прав адміністратора для цієї дії."
    end
  end

  # ЛОГІКА СТВОРЕННЯ КАТЕГОРІЇ ТА ОНОВЛЕННЯ ПАРАМЕТРІВ
  def create_category_if_needed
    if params[:new_category_name].present?
      new_category_name = params[:new_category_name]

      new_category = Category.find_or_create_by(name: new_category_name) do |cat|
        cat.description = "Автоматично створена категорія"
      end

      if new_category.persisted?
        # Додаємо ID до хешу params[:product]
        params[:product] = product_params.merge(category_id: new_category.id)
      else
        @product ||= Product.new
        @product.errors.add(:category, "не вдалося створити: #{new_category.errors.full_messages.join(', ')}")
        flash.now[:alert] = "Не вдалося створити нову категорію: #{new_category.errors.full_messages.join(', ')}"
      end
    end
  end

  # Обмежує параметри, які можна оновлювати
  def product_params
    params.require(:product).permit(:name, :description, :price, :category_id, :image_url)
  end
end
