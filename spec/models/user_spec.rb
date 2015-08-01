require 'spec_helper'

describe User do
  it { should have_many(:reviews) }
  it { validate_presence_of(:email) }
  it { validate_presence_of(:full_name) }
  it { validate_presence_of(:password) }
  it { validate_length_of(:password).is_at_least(6) }
  it { should have_many(:queue_items).order(:position) }

  describe "#authenticate" do
    it "should return object when password is correct" do
      joe = Fabricate(:user, password: "123456")
      expect(joe.authenticate("123456")).to eq(joe)
    end

    it "should return false when password is correct" do
      joe = Fabricate(:user, password: "123456")
      expect(joe.authenticate("wrong password")).to eq(false)
    end
  end

end
