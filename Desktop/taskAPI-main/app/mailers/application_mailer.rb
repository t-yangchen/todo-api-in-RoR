class ApplicationMailer < ActionMailer::Base
  default from: 'hellofromtodoapi@gmail.com'
  # layout 'mailer'
  def send_email(user, subject, body)
    @user = user
    mail(to: @user.email, subject: subject, body: body)
  end
  
end
