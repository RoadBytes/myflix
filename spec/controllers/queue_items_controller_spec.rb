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

    before :each do
      session[:user_id] = picky_user.id
      delete :destroy, id: queue_item_one.id
    end

    it "removes the associated item from the user's queue" do
      expect(picky_user.queue_items).to_not include(queue_item_one)
    end

    it "redirects to queue_item#index template" do
      expect(response).to redirect_to my_queue_path
    end
  end
end
