require 'spec_helper'

describe VideosController do
  describe "GET #show" do
    let(:video) { create(:video) }

    context "with authenticated user" do
      before :each do
        session[:user_id] = create(:user).id
        get :show, id: video.id
      end

      it "sets @video" do
        expect(assigns(:video)).to eq video
      end

      it "sets @review" do
        expect(assigns(:review)).to be_a Review
      end
    end

    context "with unauthenticated user" do
      it "redirects to root_path" do
        get :show, id: video.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #search" do
    let(:monk) { create(:video, title: "Monk") }

    it "assigns the appropriate videos from the database with authenticated user" do
      session[:user_id] = create(:user).id
      post :search, search: "m"
      expect(assigns(:search_result)).to eq([monk])
    end

    it "redirects to root without authenticated user" do
      post :search, search: "m"
      expect(response).to redirect_to root_path
    end
  end
end
