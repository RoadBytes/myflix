require 'spec_helper'

describe QueueItem do
  it { should validate_numericality_of(:position).only_integer }

  describe "#rating" do
    it "returns user's rating of video if review exists" do
      rating_user  = Fabricate(:user)
      rated_video  = Fabricate(:video)
      video_review = Fabricate(:review, rating: 3, user: rating_user, video: rated_video)
      queue_item   = Fabricate(:queue_item, user: rating_user, video: rated_video)
      expect(queue_item.rating).to eq 3
    end

    it "returns nil if there is no user rating" do
      user       = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: Fabricate(:video))
      expect(queue_item.rating).to eq nil
    end
  end

  describe "#rating=" do
    it "changes the rating of the review if review is present" do
      video             = Fabricate(:video)
      user              = Fabricate(:user)
      review            = Fabricate(:review, user: user, video: video)
      queue_item        = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end

    it "clears the rating of the review if review is present" do
      video             = Fabricate(:video)
      user              = Fabricate(:user)
      review            = Fabricate(:review, user: user, video: video)
      queue_item        = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil
      expect(Review.first.rating).to eq(nil)
    end

    it "creates a review with rating if the review is not present" do
      video             = Fabricate(:video)
      user              = Fabricate(:user)
      queue_item        = Fabricate(:queue_item)
      queue_item.rating = 3
      expect(Review.first.rating).to eq(3)
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
