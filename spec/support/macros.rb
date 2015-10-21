def set_current_user user
  session[:user_id] = (user || Fabricate(:user)).id
end
