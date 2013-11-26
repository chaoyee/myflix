class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:leader_id])
    if current_user.can_follow?(leader)
      relationship = Relationship.new(leader_id: params[:leader_id], follower_id: current_user.id)
      if relationship.save
        flash[:notice] = "You have followed #{leader.full_name}."  
        redirect_to people_path   
      else
        flash[:error] = relationship.errors.full_messages.join(', ')
        redirect_to user_path(leader.id)
      end
    else
      redirect_to user_path(leader.id)
    end 
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
