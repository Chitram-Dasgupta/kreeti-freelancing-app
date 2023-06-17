class UsersController < ApplicationController
  skip_before_action :require_authorization, only: %i[new create show confirm_email]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_later
      redirect_to root_path, notice: 'Thank you for signing up!'
    else
      flash.now[:error] = 'Please try again'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update!(user_params)
      redirect_to @user, notice: 'Profile updated'
    else
      flash[:error] = 'Please enter the data properly'
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_email
    user = User.find_by_confirmation_token(params[:token])
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
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :name, :qualification, :experience, :industry, :profile_picture)
  end
end
