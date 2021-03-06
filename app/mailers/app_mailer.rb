class AppMailer < ActionMailer::Base
  default from: 'info@myflix.com'
  
  def welcome_user(user)
    @user = user
    mail to: user.email, subject: "You are awesome"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, subject: "Password Reset Requested"
  end

  def send_invitation invitation
    @invitation = invitation
    mail to: invitation.recipient_email, subject: "Hey, Join MyFlix"
  end
end
