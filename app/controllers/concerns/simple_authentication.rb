module SimpleAuthentication
  extend ActiveSupport::Concern

  # simple authentication management methods
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def signed_in?
    !!current_user
  end

  def sign_out
    @current_user     = nil
    session[:user_id] = nil
  end
end