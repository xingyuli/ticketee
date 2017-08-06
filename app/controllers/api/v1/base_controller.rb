class Api::V1::BaseController < ActionController::Base

  before_action :authenticate_user
  before_action :check_rate_limit

  respond_to :json, :xml

  private

  def authenticate_user
    @current_user = User.find_by_authentication_token(params[:token])
    respond_with({ error: 'Token is invalid.' }) unless @current_user
  end

  def authorize_admin!
    unless @current_user.admin?
      error = { error: 'You must be an admin to do that.' }

      # The reason for doing it this way rather than using
      #   respond_with error, status: 401
      # is because respond_with will attempt to do some weird behavior and
      # doesn't work for POST requests, so you must work around that little
      # issue.
      render params[:format].to_sym => error, :status => 401
    end
  end

  def current_user
    @current_user
  end

  def check_rate_limit
    if @current_user.request_count > 100
      error = { error: 'Rate limit exceeded.' }
      respond_with error, status: 403
    else
      @current_user.increment!(:request_count)
    end
  end

end