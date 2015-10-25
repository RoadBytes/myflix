require "spec_helper"

feature "user adds to my_queue and changes order" do
  scenario "authenticated user" do
    comedies   = Fabricate(:category)
    monk       = Fabricate(:video, title: "Monk", category: comedies)
    south_park = Fabricate(:video, title: "South Park", category: comedies)
    huck       = Fabricate(:video, title: "Huck", category: comedies)
    user       = User.create(full_name: "Yo Yo", email: "yo@test.com", password: "123456")

    sign_in_user user

    find("a[href='/videos/#{monk.id}']").click
    expect(page).to have_content monk.title

    click_on '+ My Queue'
    expect(page).to have_content monk.title

    click_link monk.title
    expect(page.find(:css, "div.video_info > header > h3").text).to have_content monk.title
    expect(page).not_to have_content '+ My Queue'

    visit home_path
    find("a[href='/videos/#{south_park.id}']").click
    click_on '+ My Queue'

    visit home_path
    find("a[href='/videos/#{huck.id}']").click
    click_on '+ My Queue'

    fill_in "video_#{monk.id}",       with: 3
    fill_in "video_#{south_park.id}", with: 1
    fill_in "video_#{huck.id}",       with: 2

    click_button "Update Instant Queue"

    expect(find("#video_#{south_park.id}").value).to eq "1"
    expect(find("#video_#{huck.id}").value).to       eq "2"
    expect(find("#video_#{monk.id}").value).to       eq "3"
  end
end
