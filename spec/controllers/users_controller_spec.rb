require "spec_helper"

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end  
  end  

  describe "POST create" do
    context "Successful user sign up" do            
      it "redirect to the sign_in page" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
    end

    context "failed user sign up" do
      let(:charge) { double(:charge, successful?: false, error_message: "Your card was declined!") }
      before do      
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123211'
      end 
      it "renders the new template" do
        expect(response).to render_template :new
      end
      it "shows the flash error message" do
        expect(flash[:error]).to be_present
      end     
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