class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :rating, :content
  # validates_uniqueness_of :user_id, scope: :video_id
end