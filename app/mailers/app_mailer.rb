class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: 'Welcome to Myflix!'
  end 
  def send_forgot_password(user)
    @user = user
    mail from: 'info@myflix.com', to: user.email, subject: 'Please Reset Your Password!'   
  end 
  def send_invitation_email(invitation)
    @invitation = invitation
    mail from: 'info@myflix.com', to: invitation.recipient_email, subject: 'Invitation to join Myflix!' 
  end
end