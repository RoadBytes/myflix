class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def show
    @user = User.where(id: params[:id]).first
  end

  def create
    @user = User.new(user_params)

    if @user.save
      AppMailer.welcome_user(@user).deliver
      flash[:success] = "Welcome, you are now registered"
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
