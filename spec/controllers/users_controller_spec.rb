# require "spec_helper"

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end  
  end  

  describe "POST create" do
    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)  # {email: "test@test.com", password: "password", full_name: "Test Test!"}    
      end

      it "creates the user" do
        expect(User.count).to eq(1)
      end  
      it "redirect to the sign_in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with invalid input" do
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
end  