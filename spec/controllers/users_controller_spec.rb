require 'spec_helper'

describe UsersController do
  describe "GET #new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "GET #new_with_invitation_token" do
    context "with valid token" do
      it "sets @user with recipient email" do
        invitation =  Fabricate(:invitation, token: "12345")
        get :new_with_invitation_token, token: "12345"
        expect(assigns(:user).email).to eq invitation.recipient_email
      end

      it "sets @invitation_token with invitation.token" do
        invitation =  Fabricate(:invitation, token: "12345")
        get :new_with_invitation_token, token: "12345"
        expect(assigns(:invitation_token)).to eq invitation.token
      end

      it "renders to :new" do
        Fabricate(:invitation, token: "12345")
        get :new_with_invitation_token, token: "12345"
        expect(response).to render_template :new
      end
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: "12345"
      expect(response).to redirect_to invalid_token_path
    end
  end

  describe "POST .create" do
    context "with valid input not from invitation" do
      before do
        VCR.use_cassette('UsersController/POSTcreate/not_from_invitation') do
          Stripe.api_key   = ENV['stripe_test_secret_key'] || sk_test_pXabwpEi2zQZdvvHW6qOxjGW
          token = Stripe::Token.create(
            :card => {
              :number    => "4242424242424242",
              :exp_month => 6,
              :exp_year  => 2018,
              :cvc       => 123
            }
          ).id

          post :create, user: {full_name: "Joe Joe", 
                               email: "email@email.com", 
                               password: "123456"}, 
                        stripeToken: token
        end
      end

      after { ActionMailer::Base.deliveries.clear }

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

    context "with valid input from invitation" do
      before do
        @alice      = Fabricate(:user)
        @invitation = Fabricate(:invitation, inviter: @alice, 
                               recipient_email: 'joe@example.com')
        VCR.use_cassette('UsersController/POSTcreate/from_invitation') do
          Stripe.api_key   = ENV['stripe_test_secret_key'] || sk_test_pXabwpEi2zQZdvvHW6qOxjGW
          token = Stripe::Token.create(
            :card => {
              :number    => "4242424242424242",
              :exp_month => 6,
              :exp_year  => 2018,
              :cvc       => 123
            }
          ).id
          post :create, user: { email:     'joe@example.com', 
                                full_name: 'Joe Doe',
                                password:  '123456'},
                        invitation_token: @invitation.token,
                        stripeToken: token
        end
      end

      after { ActionMailer::Base.deliveries.clear }

      it "has user follow inviter" do
        joe = User.find_by(email: 'joe@example.com')
        expect(joe.is_following?(@alice)).to be true
      end

      it "has inviter follow user" do
        joe = User.find_by(email: 'joe@example.com')
        expect(@alice.is_following? joe).to be true
      end

      it "deletes invitation token upon acceptance" do
        expect(@invitation.reload.token).to be_nil
      end
    end

    context "with invalid input" do
      before { post :create, user: {full_name: "Joe Joe", email: "", password: "123456"}}

      it "does not save to database" do
        expect(User.count).to eq 0
      end

      it "renders :new template" do
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
