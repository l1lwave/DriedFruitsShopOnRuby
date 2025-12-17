class Admin::CallbackRequestsController < ApplicationController
  before_action :require_login
  before_action :require_admin

  # GET /admin/callback_requests
  def index
    # Відображаємо всі запити, від найновіших до найстаріших
    @requests = CallbackRequest.order(created_at: :desc)
  end

  # DELETE /admin/callback_requests/:id (для очищення всього списку)
  def destroy
    # Видаляємо всі запити
    CallbackRequest.delete_all
    redirect_to admin_callback_requests_path, notice: "Список запитів на зворотній дзвінок успішно очищено."
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Доступ заборонено."
    end
  end
end
