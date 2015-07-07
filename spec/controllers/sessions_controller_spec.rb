require 'spec_helper'

describe SessionsController do
  describe "GET #new" do
    it "redirects to home_path if there's a current_user" do
      session[:user_id] = Fabricate(:user)
      get :new
      expect(response).to redirect_to home_path 
    end
  end

  describe "POST #create" do
    context "with password/credentials correct" do
      let(:signed_in_user) { Fabricate(:user) }
      before :each do
        post :create, email: signed_in_user.email, password: signed_in_user.password
      end

      it "puts signed_in_user in a session" do
        expect(session[:user_id]).to eq(signed_in_user.id)
      end

      it "redirects to home_path" do 
        expect(response).to redirect_to home_path 
      end

      it "has a flash success message" do
        expect(flash[:success]).to_not be_blank
      end
    end

    context "with password/credentials incorrect" do
      before :each do
        unauthenticated_user = Fabricate(:user, password: "password")
        post :create, email: unauthenticated_user.email, password: "wrong_password"
      end

      it "redirects to signin_path" do
        expect(response).to redirect_to signin_path 
      end

      it "does not put unauthenticated_user in a session" do
        expect(session[:user_id]).to eq(nil)
      end

      it "has a flash danger message" do
        expect(flash[:danger]).to_not be_blank
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      session[:user_id] = Fabricate(:user).id
      delete :destroy
    end

    it "clears out session" do
      expect(session[:user_id]).to eq nil
    end

    it "redirects to root_path" do
      expect(response).to redirect_to root_path
    end

    it "has a flash success message" do
      expect(flash[:success]).to_not be_blank
    end
  end
end
