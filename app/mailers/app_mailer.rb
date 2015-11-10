class AppMailer < ActionMailer::Base
  def notify_on_new_todo(user, todo)
    @todo = todo
    mail from: 'info@myflix.com', to: user.email, subject: "You are awesome"
  end
end
