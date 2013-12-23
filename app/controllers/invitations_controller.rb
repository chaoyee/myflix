class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end 

  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver 
      flash[:success] = 'The invitation email has been sent!'
      redirect_to new_invitation_path
    else
      flash[:error] = @invitation.errors.full_messages.join(", ")
      render :new
    end   
  end

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message).merge!(inviter_id: current_user.id)
  end   
end