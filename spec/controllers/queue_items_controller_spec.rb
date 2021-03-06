require 'spec_helper'

describe QueueItemsController do
  describe "GET #index" do
    it "sets @queue_items for authenticated user" do
      signed_in_user = Fabricate(:user)
      set_current_user signed_in_user
      queue_item_one    = Fabricate(:queue_item, user: signed_in_user)
      queue_item_two    = Fabricate(:queue_item, user: signed_in_user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item_one, queue_item_two])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE #destroy" do
    let(:picky_user)     { Fabricate(:user) }
    let(:queue_item_one) { Fabricate(:queue_item, user: picky_user) }
    let(:queue_item_two) { Fabricate(:queue_item, user: picky_user) }

    context "Authenticated User" do
      before :each do
        set_current_user picky_user
      end

      it "removes the associated item from the user's queue" do
        delete :destroy, id: queue_item_one.id
        expect(picky_user.queue_items).to_not include(queue_item_one)
      end

      it "redirects to queue_item#index template" do
        delete :destroy, id: queue_item_one.id
        expect(response).to redirect_to my_queue_path
      end

      it "normalizes the queue when an item is deleted" do
        queue_item_one.position = 1
        queue_item_two.position = 2
        delete :destroy, id: queue_item_one.id
        expect(queue_item_two.reload.position).to eq(1)
      end

      it "does not delete non current_user queue items" do
        non_signed_in_user = Fabricate(:user)
        non_signed_in_user_queue_item = Fabricate(:queue_item, user: non_signed_in_user)
        delete :destroy, id: non_signed_in_user_queue_item.id
        expect(QueueItem.count).to eq(1)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: queue_item_one.id }
    end
  end

  describe "POST #create" do
    let(:authenticated_user) { Fabricate(:user) }

    before :each do
      set_current_user authenticated_user
      @queue_item_one = QueueItem.new(user: authenticated_user)
    end

    it "adds item to current_users queue items" do
      post :create, video: @queue_item_one.video
      expect(QueueItem.count).to eq 1
    end

    it "redirects to /my_queue" do
      post :create, video: @queue_item_one.video
      expect(response).to redirect_to my_queue_path
    end

    it "sets queue_item list position to last value" do
      4.times { |count| Fabricate(:queue_item, user: authenticated_user, position: count + 1) }
      post :create, video: @queue_item_one.video
      expect(authenticated_user.queue_items.last.position).to eq 5
    end

    it "does not add video to queue if it's already in queue" do
      @queue_item_one.save
      video = @queue_item_one.video
      post :create, video: @queue_item_one.video
      expect(QueueItem.count).to eq 1
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end
  end

  describe "POST #order" do
    context "with valid inputs" do
      let(:signed_in_user) { Fabricate(:user) }

      before :each do
        set_current_user signed_in_user
        @queue_item_one = Fabricate(:queue_item, user: signed_in_user, position: 1)
        @queue_item_two = Fabricate(:queue_item, user: signed_in_user, position: 2)
      end

      it "redirects to the my queue page" do
        post :order, queue_items: [{id: @queue_item_one.id, position: 2}, {id: @queue_item_two.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :order, queue_items: [{id: @queue_item_one.id, position: 2}, {id: @queue_item_two.id, position: 1}]
        expect(signed_in_user.queue_items).to eq([@queue_item_two.reload, @queue_item_one.reload])
      end

      it "normalizes the position numbers" do 
        post :order, queue_items: [{id: @queue_item_one.id, position: 3}, {id: @queue_item_two.id, position: 4}]
        expect(signed_in_user.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do
      let(:signed_in_user) { Fabricate(:user) }

      before :each do
        set_current_user signed_in_user
        @queue_item_one = Fabricate(:queue_item, user: signed_in_user, position: 1)
        @queue_item_two = Fabricate(:queue_item, user: signed_in_user, position: 2)
      end

      it "redirects to my queue page" do
        post :order, queue_items: [{id: @queue_item_one.id, position: 2.5}, {id: @queue_item_two.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash[:danger] message" do
        post :order, queue_items: [{id: @queue_item_one.id, position: 2.5}, {id: @queue_item_two.id, position: 1}]
        expect(flash[:danger]).to be_present
      end

      it "does not change the queue items" do
        post :order, queue_items: [{id: @queue_item_one.id, position: 3}, {id: @queue_item_two.id, position: 2.1}]
        expect(signed_in_user.queue_items.first).to eq(@queue_item_one)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :order, queue_items: [{id: 1, position: 3}, {id: 2, position: 2}] }
    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        signed_in_user = Fabricate(:user)
        set_current_user = signed_in_user
        queue_item_one = Fabricate(:queue_item, user: signed_in_user, position: 1)
        queue_item_two = Fabricate(:queue_item, position: 4)
        post :order, queue_items: [{id: queue_item_one.id, position: 3}, {id: queue_item_two, position: 5}]
        expect(queue_item_one.reload.position).to eq(1)
      end
    end
  end
end
