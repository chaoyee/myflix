require 'spec_helper'

describe User do
  it { should validate_presence_of(:email)}
  it { should validate_presence_of(:password)}
  it { should validate_presence_of(:full_name)}
  it do 
    User.create(email: "test@test.com", password: "password", full_name: "Tester Tester")
    should validate_uniqueness_of(:email)
  end
  it { should have_many(:reviews).order(created_at: :desc)}
  it { should have_many(:queue_items).order(position: :asc)}
  it { should have_secure_password }

  it "generates a random token when the user is created" do
    bob = Fabricate(:user)
    expect(bob.token).to be_present
  end

  describe "#follows?" do
    let(:bob)  { Fabricate(:user) }
    let(:joe)  { Fabricate(:user) }

    it 'returns true if the user has a following relationship with another user' do
      Fabricate(:relationship, follower: bob, leader: joe)
      expect(bob.follows?(joe)).to be_true      
    end
    it 'returns false if the user does not have a following relationship with another user' do
      Fabricate(:relationship, follower: bob, leader: joe)
      expect(joe.follows?(bob)).to be_false    
    end
  end
end  