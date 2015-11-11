class PasswordResetsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])
    
    if user
      @token = params[:id]
    else
      redirect_to invalid_token_path unless user
    end
  end

  def create
    user = User.find_by(token: params[:token])
    if user
      user.password = params[:password]
      user.generate_token
      user.save
      flash[:success] = "New Password has been set"
      redirect_to signin_path
    else
      redirect_to invalid_token_path
    end
  end

  def invalid_token
  end
end
