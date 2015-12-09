class AdminsController < ApplicationController
  before_filter :ensure_admin

  def ensure_admin
    unless current_user && current_user.admin?
      flash[:danger] = 'Access Denied'
      redirect_to root_path 
    end
  end
end
