require "spec_helper"

describe UserSignup do
  describe "#sign_up" do 
    context "valid personal info and valid card" do
      let(:customer) { double(:customer, successful?: true, customer_token: "abcdefg") }
      
      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end
      after do
        ActionMailer::Base.deliveries.clear
      end

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end
      it "stroes the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.first.customer_token).to eq("abcdefg")
      end
      it "makes the user follow the inviter" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'charles@test.com')
        UserSignup.new(Fabricate.build(:user, email: 'charles@test.com', password: 'password', full_name: 'Charles Test')).sign_up("some_stripe_token", invitation.token)
        charles = User.where(email: 'charles@test.com').first
        expect(charles.follows?(bob)).to be_true
      end
      it "makes the inviter follow the user" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'charles@test.com')
        UserSignup.new(Fabricate.build(:user, email: 'charles@test.com', password: 'password', full_name: 'Charles Test')).sign_up("some_stripe_token", invitation.token)
        charles = User.where(email: 'charles@test.com').first
        expect(bob.follows?(charles)).to be_true
      end
      it "expires the invitation upon acceptance" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'charles@test.com')
        UserSignup.new(Fabricate.build(:user, email: 'charles@test.com', password: 'password', full_name: 'Charles Test')).sign_up("some_stripe_token", invitation.token)
        expect(Invitation.first.token).to be_nil
      end
      it 'sends out the email' do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        ActionMailer::Base.deliveries.should_not be_empty
      end
      it 'sends to the right recipent' do
        UserSignup.new(Fabricate.build(:user, email: 'test@test.com')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['test@test.com'])
      end
      it 'has the right content' do
        UserSignup.new(Fabricate.build(:user, full_name: 'Charles Test')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include('Charles Test')
      end
    end

    context "valid personal information and declined card" do
      let(:customer) { double(:customer, successful?: false, error_message: "Your card was declined!") }
      it "does not create a new user record" do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up("123211", nil)  
        expect(User.count).to eq(0)
      end    
    end

    context "with invalid personal information" do
      before do   
        UserSignup.new(User.new(email: "test@example.com")).sign_up("123211", nil)  
      end 
      
      after do
        ActionMailer::Base.deliveries.clear
      end

      it "does not create user" do
        expect(User.count).to eq(0)
      end        
      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:create)
      end
      it "does not send out email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end 
    end 
  end  
end