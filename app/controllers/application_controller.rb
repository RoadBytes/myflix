class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user 

  def block_client
    flash[:danger] = "Not Allowed"
    redirect_to root_path
  end

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end

  def require_user
    block_client if !logged_in?
  end
end
