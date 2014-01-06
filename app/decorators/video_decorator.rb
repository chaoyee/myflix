class VideoDecorator < Draper::Decorator
  delegate_all
  
  def rating
    if object.respond_to?(:rating)
      object.rating.present? ? "#{object.rating}/5.0" : "N/A"  
    else
      "N/A"
    end  
  end  
end  