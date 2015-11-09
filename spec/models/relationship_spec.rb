require 'spec_helper'

describe Relationship do
  it { should belong_to(:follower) }
  it { should belong_to(:leader) }

  it { should validate_uniqueness_of(:leader_id).scoped_to(:follower_id) }
end
