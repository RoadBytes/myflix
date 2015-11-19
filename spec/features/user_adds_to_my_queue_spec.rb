require "spec_helper"

feature "user adds to my_queue and changes order" do
  scenario "authenticated user" do
    comedies   = Fabricate(:category)
    monk       = Fabricate(:video, title: "Monk", category: comedies)
    south_park = Fabricate(:video, title: "South Park", category: comedies)
    huck       = Fabricate(:video, title: "Huck", category: comedies)
    user       = Fabricate(:user,  full_name: "Yo Yo", email: "yo@test.com", password: "123456")

    sign_in_user user

    visit_video_page_of monk

    check_my_queue_button_disappears monk

    place_in_queue south_park
    place_in_queue huck

    change_queue_position monk,       3
    change_queue_position south_park, 1
    change_queue_position huck,       2

    click_button "Update Instant Queue"

    expect_video_position south_park, "1"
    expect_video_position huck,       "2"
    expect_video_position monk,       "3"
  end

  def visit_video_page_of video
    find("a[href='/videos/#{video.id}']").click
    expect(page).to have_content video.title
  end

  def place_in_queue video
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_on '+ My Queue'
  end

  def check_my_queue_button_disappears video
    click_on '+ My Queue'
    click_link video.title
    expect(page.find(:css, "div.video_info > header > h3").text).to have_content video.title
    expect(page).not_to have_content '+ My Queue'
  end

  def change_queue_position video, value
    fill_in "video_#{video.id}", with: value
  end

  def expect_video_position video, value
    expect(find("#video_#{video.id}").value).to eq value
  end
end
