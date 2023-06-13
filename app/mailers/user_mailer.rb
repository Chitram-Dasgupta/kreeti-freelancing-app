class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    # @login_link = login_link
    mail to: @user.email, subject: 'Account activation'
  end

  def registration_confirmation(user)
    @user = user
    mail to: @user.email, subject: 'Registration Confirmation'
 end
end
