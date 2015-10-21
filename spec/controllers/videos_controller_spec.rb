require 'spec_helper'

describe VideosController do
  describe "GET #show" do
    let(:video) { Fabricate(:video) }

    context "with authenticated user" do
      before :each do
        set_current_user
        get :show, id: video.id
      end

      it "sets @video" do
        expect(assigns(:video)).to eq video
      end

      it "sets @review" do
        expect(assigns(:review)).to be_a Review
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: video.id }
    end
  end

  describe "POST #search" do
    let(:monk) { Fabricate(:video, title: "Monk") }

    it "assigns the appropriate videos from the database with authenticated user" do
      set_current_user
      post :search, search: "m"
      expect(assigns(:search_result)).to eq([monk])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :search, search: "m" }
    end
  end
end
