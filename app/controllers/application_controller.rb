class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_states

  private

  def require_signin!
    if current_user.nil?
      redirect_to signin_url, flash: { error: 'You need to sign in or sign up before continuing.' }
    end
  end
  helper_method :require_signin!

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize_admin!
    require_signin!

    unless current_user.admin?
      redirect_to root_path, alert: 'You must be an admin to do that.'
    end
  end

  def find_states
    @states = State.all
  end

end
