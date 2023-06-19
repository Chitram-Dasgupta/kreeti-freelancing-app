class UsersController < ApplicationController
  skip_before_action :require_authorization, only: %i[new create show confirm_email search]
  before_action :set_user, only: %i[show edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_later
      redirect_to root_path, flash: { notice: 'Please check your email for activation link' }
    else
      flash.now[:error] = 'Please enter the data properly'
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update!(user_params)
      redirect_to @user, flash: { success: 'Profile updated successfully' }
    else
      flash.now[:error] = 'Please enter the data properly'
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_email
    user = User.find_by(confirmation_token: params[:token])
    if user
      user.email_activate
      redirect_to new_session_path, flash: { success: 'Your email has been confirmed. Please sign in to continue.' }
    else
      redirect_to root_path, flash: { error: 'Sorry. User does not exist' }
    end
  end

  def search
    @users = if params[:search].present?
               User.search_freelancer(params[:search]).records
             else
               User.all
             end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :name, :qualification, :experience,
                                 :industry, :profile_picture)
  end
end
