require "spec_helper"

feature "admin user adds new video" do
  scenario "Admin successfully adds video" do
    drama = Fabricate(:category, name: "Drama")
    admin = Fabricate(:admin)

    sign_in_user admin
    visit new_admin_video_path
    fill_in_new_video_form
    signout

    sign_in_user
    check_for_added_video
  end

  def  fill_in_new_video_form
    fill_in     "Title",       with: "Monk"
    select      "Drama",       from: "Category"
    fill_in     "Description", with: "Great crazy show"
    attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small cover", "spec/support/uploads/monk.jpg"
    fill_in     "Video URL",   with: "http://movie.com/my_vid.mp4"
    click_on    "Add Video"
    expect(page).to have_content("New video titled: Monk created")
  end

  def check_for_added_video
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://movie.com/my_vid.mp4']")
  end
end
