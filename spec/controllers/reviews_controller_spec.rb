require "spec_helper"

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }

    context "with authenticated users" do   
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }
      
      context "with valid input" do
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id 
        end  
        it "create a review" do        
          expect(Review.count).to eq(1)
        end  
        it "create a review associated with the video" do
          expect(Review.first.video).to eq(video) 
        end  
        it "create a review associated with the sign in user" do
          expect(Review.first.user).to eq(current_user) 
        end  
        it "redirect_to video show page" do
          expect(response).to redirect_to video_path(video)
        end  
      end
      context "with invalid input" do
        it "does not create review" do        
          post :create, review: {rating: 3} , video_id: video.id 
          expect(Review.count).to eq(0)
        end 
        it "renders 'videos/show' template" do
          post :create, review: {rating: 3} , video_id: video.id 
          expect(response).to render_template "videos/show"
        end 
        it "sets @video" do
          post :create, review: {rating: 3} , video_id: video.id 
          expect(assigns(:video)).to eq(video)
        end
        it "sets @reviews" do
          review = Fabricate(:review, video: video)
          post :create, review: {rating: 3} , video_id: video.id 
          expect(assigns(:reviews)).to match_array([review])
        end      
      end
    end
    context "with unauthenticated users" do
      it "redirects to the sign in page" do
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id 
        expect(response).to redirect_to sign_in_path
      end
    end    
  end  
end