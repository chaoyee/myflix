class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    relationship = Relationship.find(params[:id])
    if current_user == relationship.follower    
      if relationship.destroy
        flash[:notice] = 'The relationship has been deleted!'
      else
        flash[:error] = relationship.errors.full_messages.join(', ')  
      end
    end  
    redirect_to people_path
  end  
end
