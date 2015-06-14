require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }

  it "should not validate a user with password less than 6 characters" do
    joe = build(:user, password: "12345")
    expect(joe.valid?).to eq(false)
  end

  it "should validate a user with a password equal to 6 characters" do
    joe = build(:user, password: "123456")
    expect(joe.valid?).to eq(true)
  end

  it "should validate a user with a password more than 6  characters" do
    joe = build(:user, password: "1234567")
    expect(joe.valid?).to eq(true)
  end

  describe "#authenticate" do
    it "should return object when password is correct" do
      joe = create(:user, password: "123456")
      expect(joe.authenticate("123456")).to eq(joe)
    end

    it "should return false when password is correct" do
      joe = create(:user, password: "123456")
      expect(joe.authenticate("12345")).to eq(false)
    end
  end

end
