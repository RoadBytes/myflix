require 'spec_helper'

describe User do
  it { validate_presence_of(:email) }
  it { validate_presence_of(:full_name) }
  it { validate_presence_of(:password) }
  it { validate_length_of(:password).is_at_least(6) }

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
