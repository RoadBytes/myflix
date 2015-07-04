require 'spec_helper'

describe QueueItemsController do
  describe "GET #index" do
    it "sets @queue_items for authenticated user" do
      signed_in_user = create(:user)
      session[:user_id] = signed_in_user.id
      queue_item_one    = create(:queue_item, user: signed_in_user, video: create(:video))
      queue_item_two    = create(:queue_item, user: signed_in_user, video: create(:video))
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item_one, queue_item_two])
    end

    it "redirects to root_path for unauthenticated user" do
      get :index
      expect(response).to redirect_to root_path
    end
  end

  describe "DELETE #destroy" do
    let(:picky_user)     { create(:user) }
    let(:queue_item_one) { create(:queue_item, user: picky_user, video: create(:video)) }
    let(:queue_item_two) { create(:queue_item, user: picky_user, video: create(:video)) }

    context "Authenticated User" do
      before :each do
        session[:user_id] = picky_user.id
      end

      it "removes the associated item from the user's queue" do
        delete :destroy, id: queue_item_one.id
        expect(picky_user.queue_items).to_not include(queue_item_one)
      end

      it "redirects to queue_item#index template" do
        delete :destroy, id: queue_item_one.id
        expect(response).to redirect_to my_queue_path
      end

      it "does not delete non current_user queue items" do
        non_signed_in_user = create(:user)
        non_signed_in_user_queue_item = create(:queue_item, user: non_signed_in_user)
        delete :destroy, id: non_signed_in_user_queue_item.id
        expect(QueueItem.count).to eq(1)
      end
    end

    it "redirects to root_path for unauthenticated users" do
      delete :destroy, id: queue_item_one.id
      expect(response).to redirect_to root_path
    end
  end

  describe "POST #create" do
    let(:authenticated_user) { create(:user) }
    let(:queue_item_one)     { build(:queue_item, user: authenticated_user, video: create(:video)) }

    context "Authenticated User" do
      before :each do
        session[:user_id] = authenticated_user.id
      end

      context "Authenticated User" do
        it "adds item to current_users queue items" do
          post :create, video_id: queue_item_one.id
          expect(QueueItem.count).to eq 1
        end

        it "redirects to /my_queue"
        it "sets queue_item list order to last value"
        it "only adds videos to queue one time"
        it "does not add item to non current_users queue items"
      end
    end

    it "redirects unauthenticated user to root path"
  end
end
