require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    let(:bob) { Fabricate(:user) }

    before do
      bob.update_column(:token, '12345')
    end
    
    it "renders show template if the token is valid" do
      get :show, id: '12345'
      expect(response).to render_template :show
    end
    it "sets @token" do
      get :show, id: '12345'
      expect(assigns(:token)).to eq('12345')
    end
    it "redirects to the expired token page if the token is invaild" do
      get :show, id: '54321'
      expect(response).to redirect_to expired_token_path
    end
  end
  describe "POST create" do
    context "with valid token" do
      let(:bob)  { Fabricate(:user, password: 'old_password') }
      
      before do
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
      end
      
      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
      it "updates the user's password" do
        expect(bob.reload.authenticate('new_password')).to be_true
      end    
      it "sets the flash success message" do
        expect(flash[:success]).to be_present
      end
      it "regenerate the user token" do
        expect(bob.reload.token).not_to eq('12345')
      end
    end
    context "with invalid token" do
      it "redirects to the expired token page" do
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end