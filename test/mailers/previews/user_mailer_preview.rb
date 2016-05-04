# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
	def user_mail_preview
		UserMailer.welcome_email(User.first)
	end
	
	def dir_mail_preview
		UserMailer.directions_email(User.first, ("Go Straight.\nTurn Left.\nArrive at place.\n").split("\n"))
	end
end
