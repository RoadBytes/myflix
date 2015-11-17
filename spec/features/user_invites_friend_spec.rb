require "spec_helper"

feature "user invites a friend" do
  scenario "successfully and invitation is accepted" do
    user = Fabricate(:user)
    sign_in_user user

    invite_a_friend
    signout

    friend_accepts_invitation
    friend_fills_in_registration

    check_account_is_following user.full_name
    signout

    sign_in_user user
    check_account_is_following "Joe Mama"

    clear_emails
  end

  def invite_a_friend
    click_link "Invite a Friend"
    fill_in "Friend's Name", with: "Joe Mama"
    fill_in "Friend's Email", with: "joe@mama.com"
    fill_in "Message", with: "Do it!"
    click_on "Send Invitation"
  end

  def signout
    click_on "dlabel"
    click_on "Sign Out"
  end

  def friend_accepts_invitation
    open_email('joe@mama.com')
    current_email.click_link "Accept this invitation"
    expect(page).to have_content "Register"
  end

  def friend_fills_in_registration
    fill_in "Password", with: "JoeMamaPassword"
    click_on "Sign Up"
    expect(page).to have_content "Welcome Joe Mama" 
  end

  def check_account_is_following leader_name
    click_on "People"
    expect(page).to have_content(leader_name)
  end
end
