require 'spec_helper'

describe Review do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:message) }

  describe "rating domain is an integer 1 to 5" do
    it { should validate_inclusion_of(:rating).in_array((1..5).to_a) }
  end
end

