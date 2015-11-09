require "spec_helper"

feature "user follows and unfollows user" do
  scenario "with existing user" do
    comedies = Fabricate(:category)
    monk     = Fabricate(:video, title: "Monk", category: comedies)

    user     = Fabricate(:user, full_name: "Yo Yo", email: "yo@test.com", password: "123456")
    leader   = Fabricate(:user, full_name: "Leader Joe", email: "leader_yo@test.com", password: "123456")

    review   = Fabricate(:review, user: leader, video: monk)

    sign_in_user user

    visit_video_page_of monk
    click_on_profile_link_of leader
    click_on_follow_button_of leader
    click_on_profile_link_of leader
    check_the_follow_link_is_gone
    click_on_people_link
    click_on_unfollow leader
    visit_home_page
    visit_video_page_of monk
    click_on_profile_link_of leader
    check_the_follow_link_is_there
  end

  def visit_video_page_of video
    find("a[href='/videos/#{video.id}']").click
    expect(page).to have_content video.title
  end

  def click_on_profile_link_of user
    find("a[href='/users/#{user.id}']").click
    expect(page).to have_content "#{user.full_name}'s video collections (#{user.queue_items.size})"
  end

  def click_on_follow_button_of user
    click_link("Follow")
    expect(page).to have_content "People I Follow"
    expect(page).to have_content user.full_name
  end

  def check_the_follow_link_is_gone
    expect(page).not_to have_content "Follow"
  end

  def click_on_people_link
    find("a[href='/people']").click
    expect(page).to have_content "People I Follow"
  end

  def click_on_unfollow user
    click_link("leader_#{user.id}")
    expect(page).not_to have_content user.full_name
  end

  def visit_home_page
    find("a[href='/home']").click
  end

  def check_the_follow_link_is_there
    expect(page).to have_content "Follow"
  end
end
