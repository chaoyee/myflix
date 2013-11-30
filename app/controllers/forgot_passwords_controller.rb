class ForgotPasswordsController < ApplicationController
  # def new   
  # end

  def create
    user = User.find_by(email: params[:email])
    if user
      AppMailer.send_forgot_password(user).deliver
      redirect_to forgot_password_confirmation_path
    else  
      flash[:error] = params[:email].blank? ? "The email address can't be blank!" : "The user does not exist in the system." 
      redirect_to forgot_password_path  
    end
  end

  def confirm
    
  end
end  