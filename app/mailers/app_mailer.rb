class AppMailer < ActionMailer::Base
  def welcome_user(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "You are awesome"
  end

  def send_forgot_password(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "Password Reset Requested"
  end
end
