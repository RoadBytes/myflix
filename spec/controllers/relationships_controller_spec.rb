require 'spec_helper'

describe RelationshipsController do
  describe "GET #index" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end

    it "sets @relationships" do
      user         = Fabricate(:user)
      set_current_user user
      leader_one   = Fabricate(:user)

      relationships = Fabricate(:relationship, follower: user, leader: leader_one)
      get :index
      expect(assigns(:relationships)).to eq [relationships]
    end
  end

  describe "DELETE #destroy" do
    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: 4 }
    end
    
    context "with authenticated user" do
      let(:user)       { Fabricate(:user) }
      let(:leader_one) { Fabricate(:user) }

      before(:each) { set_current_user user }

      it "redirects to people_path" do
        relationships = Fabricate(:relationship, follower: user, leader: leader_one)
        delete :destroy, id: relationships
        expect(response).to redirect_to people_path
      end

      it "destroys relationship of current user and leader" do
        relationship = Fabricate(:relationship, follower: user, leader: leader_one)
        delete :destroy, id: relationship
        expect(Relationship.count).to eq 0
      end

      it "does not destroy relationships where current user is the follower" do
        other_follower = Fabricate(:user)
        relationship = Fabricate(:relationship, follower: other_follower, leader: leader_one)
        delete :destroy, id: relationship
        expect(Relationship.count).to eq 1
      end
    end
  end

  describe "POST #create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    context "with authenticated user" do
      
      let(:user) { Fabricate(:user) }
      let(:leader_user) { Fabricate(:user) }

      before(:each) do
        set_current_user user
      end

      it "redirects to current_user's people page" do
        post :create
        expect(response).to redirect_to people_path
      end

      it "creates a relationship with a leader" do
        post :create, leader_id: leader_user.id
        expect(Relationship.first.leader).to eq leader_user
      end

      it "does not allow user to follow leader more than once" do
        Fabricate(:relationship, leader: leader_user, follower: user)
        
        post :create, leader_id: leader_user.id
        expect(user.leader_relationships.size).to eq 1
      end

      it "allows user to follow multiple leaders" do
        new_leader_user = Fabricate(:user)
        Fabricate(:relationship, leader: leader_user, follower: user)
        
        post :create, leader_id: new_leader_user.id
        expect(user.leader_relationships.size).to eq 2
      end

      it "does not allow user to follow themselves" do
        post :create, leader_id: user.id
        expect(user.leader_relationships.size).to eq 0
      end
    end
  end
end
