require "spec_helper"

describe QueueItem do
  it { should belong_to(:user)}
  it { should belong_to(:video)}
  it { should validate_presence_of(:video_id)}
  it { should validate_presence_of(:user_id)}  
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id)}
  it { should validate_numericality_of(:position).only_integer}
  describe "#rating" do
    let(:video)      { Fabricate(:video) }
    let(:user)       { Fabricate(:user)  }
    let(:queue_item) { Fabricate(:queue_item, user: user, video: video) }
    
    it "returns the rating from the review when the review is present" do
      review = Fabricate(:review, user: user, video: video, rating: 3)
      expect(queue_item.rating).to eq(3) 
    end
    it "returns nil when the review is not present" do
      expect(queue_item.rating).to be_nil 
    end  
    it "changes the rating of the review if the review is present" do
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item.rating = 4
      expect(QueueItem.first.rating).to eq(4) 
    end
    it "the rating must be present if the review is present" do
      review = Fabricate(:review, user: user, video: video)
      queue_item.rating = 1
      expect(QueueItem.first.rating).to eq(1)
    end
    it "creates a review with the rating if the review is not present" do
      queue_item.rating = 1
      expect(Review.count).to eq(1)
    end
    it "does not create a review if the rating and the review is not present" do
      expect(Review.count).to eq(0) 
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