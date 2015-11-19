require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new Invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    context "with valid input" do
      before do
        set_current_user
        post :create, invitation: { recipient_email: "test@gogo.com", recipient_name: "Joe Shmoe", message: "Do it!" }
      end

      after { ActionMailer::Base.deliveries.clear }

      it "redirects to invitaion new page" do
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        expect(Invitation.count).to eq 1
      end

      it "sets the invitation token" do
        expect(Invitation.first.token).to be_present
      end

      it "sends an email to recipient_email" do
        expect(ActionMailer::Base.deliveries.last.to).to eq ["test@gogo.com"]
      end

      it "sets the flash[:success]" do
        expect(flash[:success]).to be_present
      end

    end

    context "with invalid input" do
      before do 
        set_current_user
        post :create, invitation: { recipient_email: "", recipient_user: "Joe Shmoe", message: "Do it!" }
      end

      it "renders new template" do
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        expect(Invitation.count).to eq 0
      end

      it "sets @invitation" do
        expect(assigns :invitation).to be_instance_of(Invitation)
      end

      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets flash[:danger] message" do
        expect(flash[:danger]).to be_present
      end
    end
  end
end
