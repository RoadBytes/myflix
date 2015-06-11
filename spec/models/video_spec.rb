require 'spec_helper'

describe Video do
  it "has a valid factory" do
    expect(build(:video)).to be_valid
  end

  it { should belong_to(:category)}
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end
