class ProductsController < ApplicationController
  before_action :require_admin, only: %i[new create edit update destroy]

  def index
    @products = Product.all.order(created_at: :desc)
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Товар успішно додано!"
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to product_path(@product), notice: "Товар оновлено"
    else
      render :edit
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    redirect_to products_path, notice: "Товар видалено"
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :description, :image_url, :category)
  end
end
