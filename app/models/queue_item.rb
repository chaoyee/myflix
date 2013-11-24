class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of   :video_id, :user_id
  validates_uniqueness_of :video_id, scope: :user_id

  validates_numericality_of :position, { only_integer: true }

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if new_rating != ""
      if review
        review.update_column(:rating, new_rating)   
      else
        review = Review.create(user_id: user.id, video_id: video.id, rating: new_rating) 
        review.save(validate: false)
      end
    end    
  end

  def category_name
    video.category.name    
  end

  def category
    video.category    
  end 

  private

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end  