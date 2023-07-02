class ApplicationController < ActionController::Base
  before_action :require_authorization
  helper_method :current_user
  helper_method :logged_in?
  helper_method :client?
  helper_method :freelancer?
  helper_method :admin?

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def client?
    current_user&.role == 'client'
  end

  def freelancer?
    current_user&.role == 'freelancer'
  end

  def admin?
    current_user&.role == 'admin'
  end

  def require_authorization
    redirect_to new_session_path, flash: { error: 'Please sign in' } unless logged_in?
  end

  def require_admin
    redirect_to root_path, flash: { error: 'You are not authorized to view this page' } unless current_user.admin?
  end
end
