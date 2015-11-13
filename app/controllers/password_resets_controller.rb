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

    return redirect_to invalid_token_path unless user
    return render :show                   unless user.update(password: params[:password], token: nil)

    set_new_password user
  end

  def invalid_token
  end
   
  private

  def set_new_password(user)
    flash[:success] = "New Password has been set"
    redirect_to signin_path
  end
end
