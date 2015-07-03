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
end
