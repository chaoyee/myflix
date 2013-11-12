require "spec_helper"

describe SessionsController do
  describe "GET new" do
    it "render the new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end
    it "redircets to the home page for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end  
  end  

  describe "POST create" do
    context "with valid credentials" do 
      before do
        @bob = Fabricate(:user)
        post :create, email: @bob.email, password: @bob.password
      end   
      it "puts the signed in user in the session" do     
        expect(session[:user_id]).to eq(@bob.id)
      end  
      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end
      it "sets the notice" do 
        expect(flash[:notice]).not_to be_blank
      end   
    end   
    context "with invalid credentials" do 
      before do
        bob = Fabricate(:user)
        post :create, email: bob.email, password: bob.password + 'oijoihOIHF'
      end
      it "does not put the signed in user in the session" do
        expect(session[:user_id]).to be_nil
      end      
      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
      it "sets the error message" do 
        expect(flash[:error]).not_to be_blank
      end     
    end  
  end
  
  describe "POST destory" do
    before do
      session[:user_id] = Fabricate(:user).id
      post :destory
    end  
    it "clear the session for the user" do
      expect(session[:user_id]).to be_nil
    end  
    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end
    it "sets the notice" do
      expect(flash[:notice]).not_to be_blank
    end  
  end  
end  
















