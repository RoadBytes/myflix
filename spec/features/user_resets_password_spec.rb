require "spec_helper"

feature "user resets forgotten password" do
  background do
    @user = Fabricate(:user, email: "test@test.com", full_name: "Joe Joe")
    clear_emails
  end

  scenario "successfuly" do
    visit root_path
    click_link "Sign In"
    click_on "Forgot Password?"
    fill_in  :email, with: "test@test.com"
    click_on "Send Email"
    open_email('test@test.com')
    current_email.click_link 'Reset My Password'
    expect(page).to have_content "New Password"

    fill_in :password, with: "1234567"
    click_button "Reset Password"
    expect(page).to have_content "New Password has been set"

    
    fill_in :email, with: "test@test.com"
    fill_in :password, with: "1234567"
    click_button "Sign in"
    expect(page).to have_content "Welcome my child"
  end
end
