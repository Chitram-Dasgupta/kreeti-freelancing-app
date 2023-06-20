class SessionsController < ApplicationController
  skip_before_action :require_authorization, only: %i[new create activation]

  def new; end

  def create
    @user = User.find_by(email: params[:email].downcase)

    return handle_invalid_authentication unless @user&.authenticate(params[:password])
    return handle_unconfirmed_email unless @user.email_confirmed

    session[:user_id] = @user.id
    handle_successful_authentication
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, flash: { notice: 'Logged out' }
  end

  def activation; end

  private

  def handle_invalid_authentication
    flash.now[:error] = 'Invalid email or password'
    render :new, status: :unprocessable_entity
  end

  def handle_unconfirmed_email
    redirect_to root_path, flash: { error: 'Please activate your account!' }
  end

  def handle_successful_authentication
    if client?
      redirect_to projects_path, flash: { notice: 'Logged in as client!' }
    elsif freelancer?
      redirect_to bids_path, flash: { notice: 'Logged in as freelancer!' }
    else
      redirect_to admins_path, flash: { notice: 'Logged in as admin!' }
    end
  end
end
