class ReviewsController < ApplicationController
  # Відгуки доступні тільки для авторизованих користувачів
  before_action :require_login
  before_action :set_product

  # POST /products/:product_id/reviews
  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @product, notice: "Ваш відгук успішно додано!"
    else
      # Якщо помилка (наприклад, вже залишений відгук), перенаправляємо з alert.
      redirect_to @product, alert: @review.errors.full_messages.to_sentence
    end
  end

  # DELETE /products/:product_id/reviews/:id
  def destroy
    @review = @product.reviews.find(params[:id])

    # Можливість видалення тільки для автора відгуку або адміністратора
    if @review.user == current_user || current_user.admin?
      @review.destroy
      redirect_to @product, notice: "Відгук успішно видалено."
    else
      redirect_to @product, alert: "Ви не маєте прав для видалення цього відгуку."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to @product, alert: "Відгук не знайдено."
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
