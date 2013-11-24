module ApplicationHelper
  def options_for_video_reviews(selected = nil)
    options_for_select([5,4,3,2,1].map {|number| [pluralize(number, "Star"), number]}, selected)
  end 

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end 
end
