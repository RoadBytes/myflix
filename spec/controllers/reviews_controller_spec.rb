require 'spec_helper'


describe ReviewsController do
  describe "POST #create" do
    let(:current_user) { Fabricate(:user)}
    let(:video)        { Fabricate(:video) }

    context "valid input" do

      before :each do
        set_current_user current_user
        post :create, video_id: video.id, review: { message: "Sweet!", rating: "4" }
      end

      it "saves @review to database" do
        expect(Review.count).to eq 1
      end

      it "redirects to video#show" do
        expect(response).to redirect_to video_path(video)
      end

      it "has flash[:success] message" do
        expect(flash[:success]).to_not be nil
      end
    end

    context "with invalid input" do

      before :each do
        set_current_user current_user
        post :create, video_id: video.id, review: { message: "", rating: "4" }
      end

      it "redirects to show/video template" do
        expect(response).to render_template "videos/show"
      end

      it "does not save @review to database" do
        expect(Review.count).to eq 0
      end

      it "sets @review instance" do
        expect(assigns(:review)).to be_instance_of(Review)
      end

      it "sets @video instance" do
        expect(assigns(:video)).to be_instance_of(Video)
      end

      it "@review instance has errors when input is invalid" do
        expect(assigns(:review).errors.size).to be > 0
      end

      it "has flash[:danger] message" do
        expect(flash[:danger]).to_not be nil
      end

    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :create, video_id: video.id }
    end
  end
end
