require "spec_helper"

describe VideosController do
  describe "GET show" do
    it "with authenticated users set the @video variable" do
      user = User.create(email: "test@test.com", password: "password", full_name: "Test Test!")  
      session[:user_id] = user.id
      bond = Video.create(title: "Bonds", description: "Bonds test!")
      # bond = Fabricate(:video)
  
      get :show, id: bond.id
      expect(assigns(:video)).to eq(bond)
      assigns(:video).should be_instance_of(Video)
    end
  
    it "render the show template" do
      user = User.create(email: "test@test.com", password: "password", full_name: "Test Test!")  
      session[:user_id] = user.id
      bond = Video.create(title: "Bonds", description: "Bonds test!")
      get :show, id: bond.id
      response.should render_template :show
    end

    it "redirects unauthenticated users" do
      bond = Video.create(title: "Bonds", description: "Bonds test!")
      # bond = Fabricate(:video)
  
      get :show, id: bond.id
      expect(response).to redirect_to root_path
    end  
  end

  describe "POST search" do
    it "sets the @videos for authenticated users" do
      user = User.create(email: "test@test.com", password: "password", full_name: "Test Test!")  
      session[:user_id] = user.id
      bond = Video.create(title: "Bonds", description: "Bonds test!")
      # bond = Fabricate(:video)
  
      post :search, search_term: 'bon'
      expect(assigns(:videos)).to eq([bond])
    end
    it "redirects to sign in page for the unauthenticated uses" do
      bond = Video.create(title: "Bonds", description: "Bonds test!") 
      post :search, search_term: 'bon'
      expect(response).to redirect_to root_path
    end  
  end
end