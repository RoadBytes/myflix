class AdminsController < ApplicationController
  before_filter :ensure_admin

  def ensure_admin
    flash[:danger] = 'Access Denied'
    redirect_to root_path unless current_user.admin?
  end
end
