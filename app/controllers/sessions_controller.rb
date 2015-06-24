class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome my child"
      redirect_to home_path
    else
      flash[:danger] = "Error please try again"
      redirect_to signin_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You've successfully logged out"
    redirect_to root_path
  end
end

