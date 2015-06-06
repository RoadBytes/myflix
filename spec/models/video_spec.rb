require 'spec_helper'

describe Video do
  it "saves a video" do
    video = Video.new(title: "Video Name", description: "Test video title that's not too exciting")
    video.save
    video.title.should == "Video Name"
  end
end
