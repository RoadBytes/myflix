class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @invitation_token = invitation.token
      @user             = User.new(email:     invitation.recipient_email, 
                                   full_name: invitation.recipient_name)
      render :new
    else
      redirect_to invalid_token_path
    end
  end

  def show
    @user = User.where(id: params[:id]).first
  end

  def create
    @user            = User.new(user_params)
    invitation_token = params[:invitation_token]

    if @user.save
      handle_invitation invitation_token

      AppMailer.delay.welcome_user(@user)
      flash[:success] = "Welcome, you are now registered"
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def handle_invitation token
    invitation = Invitation.find_by(token: token)

    if invitation
      inviter = User.find_by id: invitation.inviter_id
      @user.follow   inviter
      inviter.follow @user
      invitation.remove_token
    end
  end
end
