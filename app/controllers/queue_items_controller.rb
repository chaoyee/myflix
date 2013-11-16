class QueueItemsController < ApplicationController
  before_action :require_user

  def index    
    @queue_items = current_user.queue_items 
  end

  def create
    queue_item = QueueItem.create(video_id: params[:video_id], user_id: current_user.id, position: new_queue_item_position)
    if queue_item.save
      flash[:notice] = "Your video has been added to your queue!"
      redirect_to queue_items_path
    else
      flash[:error] = queue_item.errors.full_messages[0]
      redirect_to :back
    end    
  end

  private

  def new_queue_item_position
    current_user.queue_items.count + 1 
  end
end