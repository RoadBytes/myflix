require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do
    before :each do
       @drama   = Fabricate(:category, name: "Drama")
       @first   = Fabricate(:video, title: "First",   created_at: 1.day.ago, category: @drama)
       @second  = Fabricate(:video, title: "Second",  created_at: 2.day.ago, category: @drama)
       @third   = Fabricate(:video, title: "Third",   created_at: 3.day.ago, category: @drama)
       @fourth  = Fabricate(:video, title: "Fourth",  created_at: 4.day.ago, category: @drama)
       @fifth   = Fabricate(:video, title: "Fifth",   created_at: 5.day.ago, category: @drama)
       @sixth   = Fabricate(:video, title: "Sixth",   created_at: 6.day.ago, category: @drama)
       @sevneth = Fabricate(:video, title: "Sevneth", created_at: 7.day.ago, category: @drama)

       @comedy         = Fabricate(:category, name: "Comedy")
       @comedy_first   = Fabricate(:video, title: "Comedy First",  created_at: 1.day.ago, category: @comedy)
       @comedy_second  = Fabricate(:video, title: "Comedy Second", created_at: 2.day.ago, category: @comedy)
       @comedy_third   = Fabricate(:video, title: "Comedy Third",  created_at: 3.day.ago, category: @comedy)
    end

    it "will return an empty array if there are no videos" do
      adventure = Fabricate(:category)
      expect(adventure.recent_videos).to eq([])
    end

    it "will return all videos if there are less than six videos in the category" do
      expect(@comedy.recent_videos).to match_array([@comedy_first, @comedy_second, @comedy_third])
    end
    
    it "will return six videos in a category" do
      expect(@drama.recent_videos.size).to eq(6)
    end

    it "will return an array of six videos ordered from recent to earlier" do
      expect(@drama.recent_videos).to eq([@first, @second, @third, @fourth, @fifth, @sixth])
    end
  end
end

