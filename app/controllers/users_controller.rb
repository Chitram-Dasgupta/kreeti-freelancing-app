# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :require_authorization, only: %i[new create show confirm_email search]
  before_action :set_user, only: %i[show edit update destroy approve reject approve reject]
  before_action :require_authorization, only: %i[destroy]
  before_action :find_user_by_confirmation_token, only: %i[confirm_email]
  before_action :require_admin, only: %i[approve reject manage_registrations]

  def index
    if admin?
      @users = User.approved_users.where.not(role: 'admin').page params[:page]
    else
      redirect_to new_user_path
    end
  end

  def show
    @user = User.visible_to(current_user).find_by(id: params[:id])
    return if @user.present?

    redirect_to root_path, flash: { error: 'You don\'t have permission to view this profile.' }
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if User.where(email: @user.email, status: 'rejected').any?
      redirect_to new_user_path, flash: { error: 'This email was previously rejected.' }
    elsif @user.save
      redirect_to root_path,
                  flash: { notice: 'Registration successful. Please wait for an admin to approve your account.' }
    else
      flash.now[:error] = 'Please enter the data properly'
      render :new, status: :unprocessable_entity
    end
  end

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
    if @user
      @user.email_activate
      if @user.errors[:confirmation_token].any?
        handle_unsuccessful_confirmation(@user)
      else
        handle_successful_confirmation
      end
    else
      redirect_to root_path, flash: { error: 'Sorry. User does not exist' }
    end
  end

  def approve
    @user.update(status: 'approved')
    UserMailer.account_activation(@user).deliver_later
    redirect_to users_path, flash: { success: 'User approved.' }
  end

  def reject
    @user.update(status: 'rejected', confirmation_token: nil)
    redirect_to users_path, flash: { success: 'User rejected.' }
  end

  def search
    @users = User.search_freelancer(params[:search]).records.page params[:page]
  end

  def manage_registrations
    @pending_users = User.pending_users.page params[:page]
  end

  def destroy
    @user.destroy
    redirect_to users_path, flash: { success: 'User deleted successfully' }
  end

  private

  def find_user_by_confirmation_token
    @user = User.find_by(confirmation_token: params[:token])
  end

  def handle_successful_confirmation
    redirect_to new_session_path, flash: { success: 'Your email has been confirmed. Please sign in to continue.' }
  end

  def handle_unsuccessful_confirmation(user)
    user.destroy
    redirect_to new_user_path, flash: { error: 'Confirmation token expired. Please sign up again.' }
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :username, :qualification,
                                 :experience, :industry, :profile_picture, :visibility)
  end
end
