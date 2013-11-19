class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of   :video_id, :user_id
  validates_uniqueness_of :video_id, scope: :user_id

  validates_numericality_of :position, { only_integer: true }

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end

  def category_name
    video.category.name    
  end

  def category
    video.category    
  end 
end  