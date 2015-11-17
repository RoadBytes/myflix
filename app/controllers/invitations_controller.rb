class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(strong_invitation_params.merge!(inviter_id: current_user.id))
    @invitation.generate_token

    if @invitation.save
      AppMailer.send_invitation(@invitation).deliver
      flash[:success] = "Invitation was sent!"
      redirect_to new_invitation_path
    else
      flash[:danger] = "Invitation was NOT sent"
      render :new
    end
  end

  private

  def strong_invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message)
  end
end
