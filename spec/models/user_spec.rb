require 'spec_helper'

describe User do
  it { should have_many(:reviews) }
  it { validate_presence_of(:email) }
  it { validate_presence_of(:full_name) }
  it { validate_presence_of(:password) }
  it { validate_length_of(:password).is_at_least(6) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC") }

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

  describe "#is_following?(user)"do
    let( :self_user )   { Fabricate(:user) }
    let( :leader_user ) { Fabricate(:user) }

    it "is true if user is a leader of self" do
      Fabricate(:relationship, follower: self_user, leader: leader_user)
      expect(self_user.is_following?(leader_user)).to be true
    end

    it "is false if user is not a leader of self" do
      non_leader = Fabricate(:user)
      expect(self_user.is_following?(non_leader)).to be false
    end
  end

  describe "#can_follow?(user)" do
    let( :self_user )   { Fabricate(:user) }
    let( :leader_user ) { Fabricate(:user) }

    it "is false when user is self" do
      expect(self_user.can_follow?(self_user)).to be false
    end

    it "is false when user is in leaders_relationships" do
      Fabricate(:relationship, follower: self_user, leader: leader_user)
      expect(self_user.can_follow?(leader_user)).to be false
    end

    it "is true when user is not self or in leader_relationships" do
      non_leader = Fabricate(:user)
      expect(self_user.can_follow?(non_leader)).to be true
    end
  end

  describe "#queued_video?" do
    let( :video ) { Fabricate(:video) }
    let( :user )  { Fabricate(:user) }

    it "returns false if video is not in user's queue" do
      expect(user.queued_video? video).to eq false
    end

    it "returns true if video is in user's queue" do
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video? video).to eq true
    end
  end
end
