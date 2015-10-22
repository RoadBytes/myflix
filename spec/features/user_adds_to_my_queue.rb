require "spec_helper"

feature "user adds to my_queue and changes order" do
  scenario "authenticated user" do
    monk       = Fabricate(:video, title: "Monk")
    south_park = Fabricate(:video, title: "South Park")
    huck       = Fabricate(:video, title: "Huck")
    user       = User.create(full_name: "Yo Yo", email: "yo@test.com", password: "123456")

    sign_in_user user

    visit "videos/#{monk.id}"
    expect(page).to have_content monk.title

    click_on '+ My Queue'
    expect(page).to have_css("#queue_items__id")

    click_link monk.title
    expect(page.find(:css, "div.video_info > header > h3").text).to have_content monk.title
    expect(page).not_to have_content '+ My Queue'
  end
end
