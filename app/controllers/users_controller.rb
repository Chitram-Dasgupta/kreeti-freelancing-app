class UsersController < ApplicationController
  skip_before_action :require_authorization, only: %i[new create confirm_email]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @token = SecureRandom.urlsafe_base64
    @login_link = "#{root_url}/login_verify?token=#{@token}&email=#{@user.email}"
    if @user.save
      # UserMailer.account_activation(@user, @login_link).deliver_later
      UserMailer.account_activation(@user).deliver_later
      redirect_to root_path, notice: 'Thank you for signing up!'
    else
      flash.now[:error] = 'Please try again'
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update; end

  def confirm_email
    user = User.find_by_confirmation_token(params[:token])
    # user = User.find_by(id: params[:id])
    if user
      user.email_activate
      flash[:success] = 'Welcome to the Sample App! Your email has been confirmed. Please sign in to continue.'
      redirect_to new_user_path
    else
      flash[:error] = 'Sorry. User does not exist'
      redirect_to root_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
