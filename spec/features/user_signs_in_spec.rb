require "spec_helper"

feature "user signs in" do
  background do
    @yo = User.create(full_name: "Yo Yo", email: "yo@test.com", password: "123456")
  end

  scenario "with existing username" do
    sign_in_user @yo
    expect(page).to have_content "Welcome my child"
  end
end
