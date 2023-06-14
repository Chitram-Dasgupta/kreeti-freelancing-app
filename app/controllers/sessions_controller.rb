class SessionsController < ApplicationController
  skip_before_action :require_authorization, only: %i[new create activation]

  def new; end

  def create
    @user = User.find_by(email: params[:email].downcase)

    if @user&.authenticate(params[:password])
      if @user.email_confirmed
        session[:user_id] = @user.id
        redirect_to projects_path, notice: 'Logged in!'
      else
        flash[:error] = 'Please activate your account!'
        redirect_to root_path
      end
    else
      flash[:error] = 'Invalid email or password'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out!'
  end

  def activation; end
end
