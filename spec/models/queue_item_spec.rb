require 'spec_helper'

describe QueueItem do
  describe "#user_rating" do
    it "returns user's rating of video if review exists" do
      rating_user  = Fabricate(:user)
      rated_video  = Fabricate(:video)
      video_review = Fabricate(:review, rating: 3, user: rating_user, video: rated_video)
      queue_item   = Fabricate(:queue_item, user: rating_user, video: rated_video)
      expect(queue_item.user_rating).to eq 3
    end

    it "returns nil if there is no user rating" do
      user       = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: Fabricate(:video))
      expect(queue_item.user_rating).to eq nil
    end
  end

  describe "#category" do
    it "returns the category of the associated video" do
      drama       = Fabricate(:category, name: "Drama")
      drama_video = Fabricate(:video, category: drama)
      queue_item  = Fabricate(:queue_item,  video: drama_video)
      expect(queue_item.category).to eq drama
    end
  end
end
