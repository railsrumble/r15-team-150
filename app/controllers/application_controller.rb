class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :chrome_user

  def chrome_user
    @chrome_user = User.find_by_chrome_app_session_id(params[:session])
  end

end
