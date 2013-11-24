class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    review = Review.new(review_params)
    if review.save
      redirect_to video_path(@video), notice: "Your review has been saved!"
    else
      flash[:error] = review.errors.full_messages.join(', ')
      @reviews = @video.reviews
      render "videos/show"
    end  
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content).merge!(video: @video, user: current_user)
  end  
end  
