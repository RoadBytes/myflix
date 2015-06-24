require 'spec_helper'

describe Video do
  it { should belong_to(:category)}
  it { should have_many(:reviews).order("created_at DESC") }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search by title" do
    before :each do
      @monk   = create(:video, title: "Monk")
      @first  = create(:video, title: "Futurama Pair")
      @second = create(:video, title: "South Park Pair")
    end

    context "no videos are found" do 
      it "returns and empty array with no matches" do
        expect(Video.search_by_title("nothingtoreturn")).to eq([])
      end

      it "returns and empty array with a blank string search" do
        expect(Video.search_by_title("")).to eq([])
      end
    end

    context "one or more video is found" do
      it "returns an array of one video" do
        expect(Video.search_by_title("Monk")).to eq([@monk])
      end
      it "returns an array of videos in order by title" do
        expect(Video.search_by_title("pair")).to eq([@first, @second])
      end
    end
  end

  describe "average_rating" do
    it "is a defined method" do
      ted = create(:video, title: "Ted")
      expect(ted).to respond_to :average_rating
    end
    
    it "returns zero with no reviews" do
      ted = create(:video, title: "Ted")
      expect(ted.average_rating).to eq 0
    end

    it "returns the average rating of all of its reviews when present" do
      jurassic_park = create(:video, title: "Jurassic Park")

      review_one    = create(:review, video_id: jurassic_park.id, rating: 5)
      review_two    = create(:review, video_id: jurassic_park.id, rating: 4)

      expect(jurassic_park.average_rating).to eq(4.5)
    end
  end
  
  describe "reviews method" do
    it "returns reviews in descending order from created_at" do
      jurassic_park = create(:video, title: "Jurassic Park")
      
      review_one    = create(:review, video_id: jurassic_park.id, 
                                      created_at: Time.now.ago(100))
      review_two    = create(:review, video_id: jurassic_park.id, 
                                      created_at: Time.now.ago(50))
      review_three  = create(:review, video_id: jurassic_park.id, 
                                      created_at: Time.now)

      expect(jurassic_park.reviews).to eq([review_three, review_two, review_one])
    end
  end
end
