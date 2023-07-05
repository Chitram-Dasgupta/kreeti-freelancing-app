class UsersController < ApplicationController
  skip_before_action :require_authorization, only: %i[new create show confirm_email search]
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_authorization, only: %i[destroy]

  def index
    if admin?
      @users = User.all.order(created_at: :asc)
    else
      redirect_to new_user_path
    end
  end

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

  def show
    return unless @user.visibility == 'priv' && @user != current_user

    redirect_to root_path, flash: { error: 'You don\'t have permission to view this profile.' }
  end

  def edit; end

  def update
    if @user.update(user_params)
      if admin?
        redirect_to users_path, flash: { success: 'Profile updated successfully' }
      else
        redirect_to @user, flash: { success: 'Profile updated successfully' }
      end
    else
      flash.now[:error] = 'Please enter the data properly'
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_email
    user = User.find_by(confirmation_token: params[:token])
    if user
      user.email_activate
      if user.errors[:confirmation_token].any?
        user.destroy
        redirect_to new_user_path, flash: { error: 'Confirmation token expired. Please sign up again.' }
      else
        redirect_to new_session_path, flash: { success: 'Your email has been confirmed. Please sign in to continue.' }
      end
    else
      redirect_to root_path, flash: { error: 'Sorry. User does not exist' }
    end
  end

  def search
    @users = if params[:search].present?
               User.search_freelancer(params[:search]).records
             else
               User.where(role: 'freelancer', visibility: 'pub')
             end
  end

  def destroy
    @user.destroy
    redirect_to users_path, flash: { success: 'User deleted successfully' }
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :username, :qualification,
                                 :experience, :industry, :profile_picture, :visibility)
  end
end
