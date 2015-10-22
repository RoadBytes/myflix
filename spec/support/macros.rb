def set_current_user user = nil
  session[:user_id] = (user || Fabricate(:user)).id
end

def sign_in_user user = nil
  user = user || Fabricate(:user)
  visit      root_path
  click_link "Sign In"
  fill_in    "Email Address", with: user.email
  fill_in    "Password",      with: user.password
  click_on   "Sign in"
end
