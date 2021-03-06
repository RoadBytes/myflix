class ForgotPasswordsController < ApplicationController
  def create
    email = params[:email]
    user  = User.find_by(email: email)

    if user
      user.generate_token
      user.save
      AppMailer.delay.send_forgot_password(user)
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = email.blank? ? 'Email cannot be blank' : 'Email not found'
      redirect_to forgot_password_path
    end
  end 

  def confirm
  end
end
