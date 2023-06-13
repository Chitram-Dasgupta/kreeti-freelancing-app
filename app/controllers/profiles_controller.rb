class ProfilesController < ApplicationController
  def show; end

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile

    if @profile.update(profile_params)
      redirect_to profile_path(current_user), notice: 'Profile updated'
    else
      flash[:error] = 'Please enter the data properly'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    if client?
      params.require(:profile).permit(:name, :industry)
    elsif freelancer?
      params.require(:profile).permit(:name, :qualification, :experience, :industry)
    end
  end
end
