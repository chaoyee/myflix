class SessionsController < ApplicationController
  def new 
    redirect_to home_path if current_user     
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = 'You have signed in!'
      redirect_to home_path
    else
      flash[:error] = 'There is something wrong with your email or password.'
      redirect_to sign_in_path
    end
  end

  def destory
    session[:user_id] = nil
    flash[:notice] = 'You have signed out!'
    redirect_to root_path
  end
end