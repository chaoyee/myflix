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
    it "normalize the remaining queue items" do
      bob = Fabricate(:user)
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, video: video1, user: bob, position: 1 )
      queue_item2 = Fabricate(:queue_item, video: video2, user: bob, position: 2 )
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)  
    end 
  end
  describe "POST update_queue" do
    context "with valid inputs" do
      it "redirects to queue items page" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: video1, user: bob, position: 1 )
        queue_item2 = Fabricate(:queue_item, video: video2, user: bob, position: 2 )
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to queue_items_path   
      end  
      it "reorders the queue items" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: video1, user: bob, position: 1 )
        queue_item2 = Fabricate(:queue_item, video: video2, user: bob, position: 2 )
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(bob.queue_items).to eq([queue_item2, queue_item1])   
      end  
      it "normalizes the position numbers" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: video1, user: bob, position: 1 )
        queue_item2 = Fabricate(:queue_item, video: video2, user: bob, position: 2 )
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 3}]
        expect(bob.queue_items.map(&:position)).to eq([1,2])   
      end  
    end  
    context "with invalid inputs" do
      it "redirects to queue item page" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: video1, user: bob, position: 1 )
        queue_item2 = Fabricate(:queue_item, video: video2, user: bob, position: 2 )
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.3}, {id: queue_item2.id, position: 4}]
        expect(response).to redirect_to queue_items_path        
      end  
      it "sets the flash error message" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: video1, user: bob, position: 1 )
        queue_item2 = Fabricate(:queue_item, video: video2, user: bob, position: 2 )
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.3}, {id: queue_item2.id, position: 4}]
        expect(flash[:error]).to be_present 
      end   
      it "does not change the queue items" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: video1, user: bob, position: 1 )
        queue_item2 = Fabricate(:queue_item, video: video2, user: bob, position: 2 )
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 4.3}]
        expect(queue_item1.reload.position).to eq(1)   
      end  
    end  
    context "with unauthenticated users" do
      it "redirects to the sign in page" do
        post :update_queue, queue_items: [{id: 1, position: 2}, {id: 2, position: 3}]
        expect(response).to redirect_to sign_in_path        
      end  
    end  
    context "with queue items that do not belong to the current user" do
      it "should not change the queue_item" do
        bob = Fabricate(:user)
        joe = Fabricate(:user)
        session[:user_id] = joe.id
        video1 = Fabricate(:video)
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: video1, user: bob, position: 1 )
        queue_item2 = Fabricate(:queue_item, video: video2, user: joe, position: 2 )
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 4}]
        expect(queue_item1.reload.position).to eq(1)   
      end  
    end  
  end  
end










