class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new    
  end

  def create
    @user = User.new(user_params)
    if @user.save
      handle_invitation
      handle_stripe
      AppMailer.send_welcome_email(@user).deliver
      redirect_to sign_in_path
    else
      render :new
    end  
  end

  def show
    @user = User.find(params[:id])
    @queue_items = @user.queue_items
    @reviews = @user.reviews
  end  

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end  
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.where(token: params[:invitation_token]).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end  
  end
  
  def handle_stripe
    # Set the stripe secret key 
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    
    # Get the credit card details submitted by the form
    token = params[:stripeToken]
    
    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      charge = Stripe::Charge.create(
        :amount => 999, # amount in cents, again
        :currency => "usd",
        :card => token,
        :description => "Sign up charge for #{@user.email}"
      )
    rescue Stripe::CardError => e
      # The card has been declined
      flash[:error] = e.message
    end   
  end  
end