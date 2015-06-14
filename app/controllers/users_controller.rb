class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Welcome, you are now registered"
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render 'new'
    end
  end

  # def change_password
  #   ...
  #   if params[:user][:password].present?
  #     @user.update_attributes(params[:user])
  #     redirect_to root_path, notice: "Success!"
  #   else
  #     flash.now.alert "Please enter password!"
  #     render "change_password"
  #   end
  # end
  
  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
