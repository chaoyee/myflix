class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    review = Review.new(review_params.merge!(video: @video, user: current_user))
    if review.save
      redirect_to video_path(@video), notice: "Your review has been saved!"
    else
      @reviews = @video.reviews
      render "videos/show"
    end  
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end  
end  