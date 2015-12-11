require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank email" do
      it "redirects to new" do
        post :create, email: ""
        expect(response).to redirect_to forgot_password_path
      end

      it "sets flash[:danger] to blank error message" do
        post :create, email: ""
        expect(flash[:danger]).to be_present
      end
    end

    context "with email not in database" do
      it "redirects to new" do
        post :create, email: "not_in@db.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "sets flash[:danger] missing error message" do
        post :create, email: "not_in@db.com"
        expect(flash[:danger]).to be_present
      end
    end

    context "existing email found" do
      let(:user) { Fabricate(:user, email: "test@test.com") }

      before(:each) { post :create, email: user.email }

      after { ActionMailer::Base.deliveries.clear }

      it_behaves_like "tokenable" do
        let(:object) { user }
      end

      it "redirects to the forgot password confirmation" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends an email to user's email" do
        expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
      end

      it "sets user's token attribute to a string value" do
        expect(user.reload.token.blank?).to_not eq true
      end
    end
  end
end
