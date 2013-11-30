require "spec_helper"

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      before do       
        post :create, email: ''
      end 

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end
      it "shows an error message" do
        expect(flash[:error]).not_to be_blank
      end
    end
    context "with existing email" do
      before do
        Fabricate(:user, email: 'joe@test.com')
        post :create, email: 'joe@test.com'
      end  
      
      it "redirects to the forgot password confirmation page" do     
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      it "sends out email to the email address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@test.com'])
      end
    end
    context "with non-existing email" do
      before do
        post :create, email: 'non-existing@test.com'
      end

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end
      it "shows the error message" do
        expect(flash[:error]).not_to be_blank
      end
    end
  end
end