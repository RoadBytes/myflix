require 'spec_helper'

describe UsersController do
  describe "GET #new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST #create" do
    context "with valid input" do
      before :each do
        post :create, user: {full_name: "Joe Joe", email: "email@email.com", password: "123456"}
      end

      it "saves @user to db with valid input" do
        expect(User.count).to eq 1
      end

      it "redirects to home_path with valid input" do
        expect(response).to redirect_to home_path
      end

      it "sends out the email" do
        ActionMailer::Base.deliveries.should_not be_empty
      end
      
      it "sends email to the right recipient" do
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq ["email@email.com"]
      end

      it "email the right content" do
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include("Welcome to MyFlix Joe Joe")
      end
    end

    context "with invalid input" do
      before(:each) { post :create, user: {full_name: "Joe Joe", email: "", password: "123456"}}

      after(:each) { ActionMailer::Base.deliveries.clear }

      it "does not save to database" do
        expect(User.count).to eq 0
      end

      it "redirects to :new" do
        expect(response).to render_template :new
      end

      it "sets @user with invalid data" do
        expect(assigns(:user)).to be_instance_of(User)
      end
      
      it "does not send out the email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET #show" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      user = Fabricate(:user)
      set_current_user user
      get :show, id: user.id
      expect(assigns(:user)).to eq user
    end
  end
end
