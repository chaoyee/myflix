require "spec_helper"

describe QueueItem do
  it { should belong_to(:user)}
  it { should belong_to(:video)}
  it { should validate_presence_of(:video_id)}
  it { should validate_presence_of(:user_id)}  
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id)}

  describe "#rating" do
    it "returns the rating from the review when the review is present" do
      video  = Fabricate(:video)
      user   = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 3)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(3) 
    end
    it "returns nil when the review is not present" do
      video  = Fabricate(:video)
      user   = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to be_nil 
    end  
  end
  describe "#category_name" do
    it "returns the category name of the video" do
      category = Fabricate(:category) 
      user = Fabricate(:user) 
      video  = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.category_name).to eq(category.name) 
    end
  end 
  describe "#category" do
    it "returns the category of the video" do
      category = Fabricate(:category)
      user = Fabricate(:user) 
      video  = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.category).to eq(category) 
    end
  end 
end