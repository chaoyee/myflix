require "spec_helper"

describe VideosController do
  describe "GET show" do
    let(:bond) { Fabricate(:video) }
    let(:bob)  { Fabricate(:user)  }

    before do
      session[:user_id] = bob.id
    end

    it "with authenticated users set the @video variable" do
      get :show, id: bond.id
      expect(assigns(:video)).to eq(bond)
      assigns(:video).should be_instance_of(Video)
    end
  
    it "sets @reviews with authenticated users" do 
      review1 = Fabricate(:review, video: bond)
      review2 = Fabricate(:review, video: bond)
      get :show, id: bond.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end  

    it "render the show template" do
      get :show, id: bond.id
      response.should render_template :show
    end

    it "redirects unauthenticated users" do
      session[:user_id] = nil
      get :show, id: bond.id
      expect(response).to redirect_to sign_in_path
    end  
  end

  describe "POST search" do
    it "sets the @videos for authenticated users" do
      session[:user_id] = Fabricate(:user) 
      bond = Video.create(title: "Bonds", description: "Bonds test!")
  
      post :search, search_term: 'bon'
      expect(assigns(:videos)).to eq([bond])
    end
    it "redirects to sign in page for the unauthenticated uses" do
      bond = Video.create(title: "Bonds", description: "Bonds test!") 
      
      post :search, search_term: 'bon'
      expect(response).to redirect_to sign_in_path
    end  
  end
end