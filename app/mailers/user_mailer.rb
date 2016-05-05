class UserMailer < ActionMailer::Base
  default from: "brandeiscampusgps@gmail.com"

  def welcome_email(user)
  	@user = user
  	@url = 'https://www.campusgps.com'
  	mail(to: @user.email, subject: 'Welcome to Campus GPS')
  end

  def directions_email(user, email_address, text)
  	@user = user
  	@str = text.split("|")
  	mail(to: email_address, subject: 'Your directions')
  end
end
