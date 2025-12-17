class Admin::BaseController < ApplicationController
  before_action :require_login
  before_action :ensure_admin

  private

  def ensure_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Доступ заборонено! Ви не є адміністратором."
    end
  end
end
