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

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    current_user.normalize_queue_item_positions
    flash[:notice] = "Your video has been removed from your queue!"
    redirect_to queue_items_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_positions
      flash[:notice] = "Your queue items have been updated!"
    rescue ActiveRecord::RecordInvalid  
      flash[:error] = "The position numbers are invalid!"
    end    
    redirect_to queue_items_path
  end

  private

  def new_queue_item_position
    current_user.queue_items.count + 1 
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data["id"])
        queue_item.update_attributes!(position: queue_item_data["position"], rating: queue_item_data["rating"]) if queue_item.user == current_user 
      end
    end
  end
end