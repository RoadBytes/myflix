require 'spec_helper'

describe Invitation do
  it { validate_presence_of(:recipient_email) }
  it { validate_presence_of(:recipient_name) }
  it { validate_presence_of(:message) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:invitation) }
  end
end
