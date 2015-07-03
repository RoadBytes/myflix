require 'spec_helper'

describe QueueItem do
  describe "#user_rating" do
    it "returns user's rating of video if review exists" do
      rating_user  = create(:user)
      rated_video  = create(:video)
      video_review = create(:review, rating: 3, user: rating_user, video: rated_video)
      queue_item   = create(:queue_item, user: rating_user, video: rated_video)
      expect(queue_item.user_rating).to eq 3
    end

    it "returns nil if there is no user rating" do
      user       = create(:user)
      queue_item = create(:queue_item, user: user, video: create(:video))
      expect(queue_item.user_rating).to eq nil
    end
  end

  describe "#category" do
    it "returns the category of the associated video" do
      drama       = create(:category, name: "Drama")
      drama_video = create(:video, category: drama)
      queue_item  = create(:queue_item, user: create(:user), video: drama_video)
      expect(queue_item.category).to eq drama
    end
  end
end
