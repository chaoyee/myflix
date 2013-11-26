require "spec_helper"

describe RelationshipsController do
  describe "GET index" do
    it "sets the @relationships to the current user's following relationships" do
      bob = Fabricate(:user)
      joe = Fabricate(:user)
      set_current_user(bob)
      relationship = Fabricate(:relationship, follower: bob, leader: joe)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end
  describe "POST create" do
    let(:bob)  { Fabricate(:user) }
    let(:joe)  { Fabricate(:user) }

    before { set_current_user(bob) }

    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 4 }
    end 
    it "creates the relationship if the current user is the follower" do
      post :create, leader_id: joe.id
      expect(bob.following_relationships.first.leader).to eq(joe)    
    end
    it "redirects to the people page" do 
      post :create, leader_id: joe.id
      expect(response).to redirect_to people_path    
    end
    it "does not create the relationship if the current user has followed the leader" do
      relationship = Fabricate(:relationship, follower: bob, leader: joe)
      post :create, leader_id: joe.id
      expect(Relationship.count).to eq(1) 
    end
    it "does not allow one to follow themselves" do
      set_current_user(bob)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(0) 
    end
  end
  describe "DELETE destroy" do
    let(:bob)  { Fabricate(:user) }
    let(:joe)  { Fabricate(:user) }

    before { set_current_user(bob) }

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 4 }
    end  
    it "deletes the relationship if the current user is the follower" do
      relationship = Fabricate(:relationship, follower: bob, leader: joe)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)    
    end
    it "redirects to the people page" do 
      relationship = Fabricate(:relationship, follower: bob, leader: joe)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path    
    end
    it "does not delete the relationship if the current user in not the follower" do
      relationship = Fabricate(:relationship, follower: joe, leader: bob)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1) 
    end
  end
end
