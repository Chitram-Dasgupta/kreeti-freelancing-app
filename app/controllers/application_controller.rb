class ApplicationController < ActionController::Base
  before_action :require_authorization
  helper_method :current_user
  helper_method :logged_in?

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def require_authorization
    redirect_to new_session_path, notice: 'Please log in' unless logged_in?
  end
end
