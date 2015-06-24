require 'spec_helper'

describe ReviewsController do
  describe "POST #create" do
    let(:video)        { create(:video) }
    let(:current_user) { create(:user) }

    context "with authenticated user" do
      context "valid input" do
        before :each do
          session[:user_id] = current_user.id
          post :create, video_id: video.id, 
                        review: attributes_for(:review, 
                                               user_id: current_user.id, 
                                               video_id: video.id)
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
          session[:user_id] = current_user.id
          post :create, video_id: video.id, 
                        review: attributes_for(:review, 
                                               message: "",
                                               user_id: current_user.id, 
                                               video_id: video.id)
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

        it "has flash[:error] message" do
          expect(flash[:error]).to_not be nil
        end
      end
    end

    context "with an unauthenticated User" do
      it "redirects the user to the front page" do
        post :create, video_id: video.id, review: attributes_for(:review)
        expect(response).to redirect_to root_path
      end
    end
  end
end

