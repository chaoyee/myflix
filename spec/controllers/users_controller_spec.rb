require "spec_helper"

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end  
  end  

  describe "POST create" do
    context "with valid personal information and valid card" do
      let(:charge) { double(:charge, successful?: true) }
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end  
      it "redirect to the sign_in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with valid input and invitation_token" do
      let(:bob)  { Fabricate(:user)  }
      let(:invitation) { Fabricate(:invitation, inviter: bob, recipient_email: 'charles@test.com') }
      let(:charge) { double(:charge, successful?: true) }
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: {email: 'charles@test.com', password: 'password', full_name: 'Charles Test'}, invitation_token: invitation.token
      end

      it "makes the user follow the inviter" do
        charles = User.where(email: 'charles@test.com').first
        expect(charles.follows?(bob)).to be_true
      end
      it "makes the inviter follow the user" do
        charles = User.where(email: 'charles@test.com').first
        expect(bob.follows?(charles)).to be_true
      end
      it "expires the invitation upon acceptance" do
        expect(Invitation.first.token).to be_nil
      end
    end

    context "valid personal information and declined card" do
      let(:charge) { double(:charge, successful?: false, error_message: "Your card was declined!") }
      before do      
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123211'
      end
      it "does not create a new user record" do  
        expect(User.count).to eq(0)
      end 
      it "renders the new template" do
        expect(response).to render_template :new
      end
      it "shows the flash error message" do
        expect(flash[:error]).to be_present
      end
    end

    context "with invalid personal information" do
      before do   
        post :create, user: {email: "test@test.com", password: "", full_name: "Test Test!"}
      end 
      
      it "does not create user" do
        expect(User.count).to eq(0)
      end  
      it "render the :new template" do
        expect(response).to render_template :new
      end    
      it "set @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
      end
      it "does not send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end 
    end 
  end

  context 'email sending' do
    let(:charge) { double(:charge, successful?: true) }
    before do
      StripeWrapper::Charge.should_receive(:create).and_return(charge)
      post :create, user: {email: "test@test.com", password: "password", full_name: "Joe Tester"}
    end 
    
    it 'sends out the email' do
      ActionMailer::Base.deliveries.should_not be_empty
    end
    it 'sends to the right recipent' do
      expect(ActionMailer::Base.deliveries.last.to).to eq(['test@test.com'])
    end
    it 'has the right content' do
      expect(ActionMailer::Base.deliveries.last.body).to include('Joe Tester')
    end
  end  

  describe "GET show" do
    let(:bob)  { Fabricate(:user)  }
    let(:bond) { Fabricate(:video) }

    before { set_current_user(bob) }

    it "set the @user variable with authenticated users " do
      get :show, id: bob.id
      assigns(:user).should eq(bob)  #be_instance_of(User)
    end
  
    it "sets @queue_items with authenticated users" do
      castle = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, video: bond, user: bob)
      queue_item2 = Fabricate(:queue_item, video: castle, user: bob)
      get :show, id: bob.id
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end  

    it "sets @reviews with authenticated users" do
      review1 = Fabricate(:review, video: bond, user: bob)
      review2 = Fabricate(:review, video: bond, user: bob)
      get :show, id: bob.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end   

    it "render the show template" do
      get :show, id: bob.id
      response.should render_template :show
    end

    it "redirects unauthenticated users" do
      session[:user_id] = nil
      get :show, id: bob.id
      expect(response).to redirect_to sign_in_path
    end  
  end
  describe "GET new_with_invitation_token" do
    it "render the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end
    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: 'abcdefg'
      expect(response).to redirect_to expired_token_path
    end
  end
end  