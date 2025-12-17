class CallbackRequestsController < ApplicationController
  # Ця дія доступна для всіх (навіть для гостей)
  # POST /callback_requests
  def create
    @callback_request = CallbackRequest.new(callback_request_params)

    if @callback_request.save
      # Успіх: Перенаправляємо на головну сторінку з повідомленням
      redirect_to root_path, notice: "✅ Запит відправлено! Ми зателефонуємо вам найближчим часом."
    else
      # Помилка: Зберігаємо помилки в flash і перенаправляємо
      flash[:alert] = "❌ Не вдалося відправити запит. " + @callback_request.errors.full_messages.to_sentence


      redirect_to root_path

    end
  end

  private

  def callback_request_params
    params.require(:callback_request).permit(:phone_number)
  end
end
