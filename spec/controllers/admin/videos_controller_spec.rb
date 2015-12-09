require 'spec_helper'

describe Admin::VideosController do
  describe "Get new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it_behaves_like "require_admin" do
      let(:action) { get :new }
    end

    it "sets the @video to a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a Video
      expect(assigns(:video)).to be_new_record
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    it_behaves_like "require_admin" do
      let(:action) { post :create }
    end

    let(:category) { Fabricate( :category ) }

    context "with valid input" do
      before do
        set_current_admin
        post :create, video: { title: "Huck", 
                               category_id: category.id, 
                               description: "A movie about love" }
      end

      it "redirects to new admin video path" do
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a new video" do
        expect(category.reload.videos.count).to eq(1)
      end

      it "it sets flash[:success]" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      before do
        set_current_admin
        post :create, video: { title: nil, 
                               category_id: category.id, 
                               description: "A movie about love" }
      end

      it "does not create new video" do
        expect(category.reload.videos.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets the @video variable" do
        expect(assigns(:video)).to be_instance_of(Video)
      end

      it "sets flash[:danger] if there's an error" do
        expect(flash[:danger]).to be_present
      end
    end
  end
end
