class UsersController < ApplicationController
  skip_before_action :require_authorization, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Thank you for signing up!'
    else
      flash.now[:error] = 'Please try again'
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update; end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
