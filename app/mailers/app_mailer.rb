class AppMailer < ActionMailer::Base
  def welcome_user(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: "You are awesome"
  end
end
