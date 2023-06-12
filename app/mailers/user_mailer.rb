class UserMailer < ApplicationMailer
  def account_activation(user, login_link)
    @user = user
    @login_link = login_link
    mail to: @user.email, subject: 'Account activation'
  end
end
