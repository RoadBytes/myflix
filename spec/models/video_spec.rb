require 'spec_helper'

describe Video do
  it { should belong_to(:category)}
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
end
