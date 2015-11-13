require 'spec_helper'

describe PasswordResetsController do

  let(:user) { Fabricate(:user, token: "12345") }

  describe "GET show" do
    context "with valid token" do
      before(:each) { get :show, id: user.token }

      it "renders show template if token is valid" do
        expect(response).to render_template :show
      end
      
      it "sets @token" do
        expect(assigns(:token)).to eq user.token
      end
    end

    it "redirects expired token template if token is invalid" do
      get :show, id: 'invalidtoken'
      expect(response).to redirect_to invalid_token_path
    end

    it "redirects expired token template if token blank" do
      get :show, id: ''
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "POST create" do
    context 'with valid token and password' do
      before(:each) do
        post :create, token: user.token, password: "123456"
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to signin_path
      end

      it "resets user password to what was input" do
        expect(user.reload.authenticate('123456')).to be_truthy
      end

      it "sets flash[:success] to reset successful message" do
        expect(flash[:success]).to be_present
      end

      it "removes the user's token" do
        expect(user.reload.token.blank?).to eq true
      end

    end

    context "with valid token and invalid password" do
      it "redirects to new if password is not valid" do
        post :create, token: user.token, password: "badpw"
        expect(response).to render_template :show
      end
    end

    context "with invalid token" do
      it "redirects to invalid token path" do
        post :create, token: "invalidtoken", password: "1234567"
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
end
