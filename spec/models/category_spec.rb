require 'spec_helper'

describe Category do
  it "has a valid factory" do
    expect(build(:category)).to be_valid
  end

  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }
end
