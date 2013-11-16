require "spec_helper"

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items for the user logged in" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: bob)
      get :index
      expect(assigns(:queue_items)).to eq([queue_item])
    end  
    it "redirects to the sign in page for the unauthenticated user" do
      get :index
      expect(response).to redirect_to sign_in_path
    end  
  end
  describe "POST create" do
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to queue_items_path  
    end  
    it "creates a queue item" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end  
    it "creates the queue item that is associated with the video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)   
    end  
    it "creates the queue item that is associated with the sin in user" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(bob)   
    end  
    it "puts the video as the last one in the queue" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: bob)
      video2 = Fabricate(:video)
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.where(video: video2, user: bob).first
      expect(video2_queue_item.position).to eq(2)   
    end    
    it "redirects to the sign in page for unauthenticated users" do
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to sign_in_path  
    end  
  end 
  describe "DELETE destroy" do
    it "redirects to the my queue page" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: bob)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to queue_items_path
    end  
    it "deletes the queue item" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end  
    it "does not delete the queue item if the queue item is not in the current user's queue" do
      bob = Fabricate(:user)
      joe = Fabricate(:user)
      session[:user_id] = bob.id
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: joe)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end  
    it "redirects to the sign in page for unauthenticated users" do
      bob = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: bob )
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to sign_in_path    
    end  
  end  
end