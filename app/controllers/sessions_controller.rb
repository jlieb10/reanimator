class SessionsController < ApplicationController
  def new
    if signed_in?
      redirect_to root_path, alert: "You are already signed in."
    else
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        sign_in(@user)
        redirect_to root_path, notice: "Successfully signed in with Google."
      else
        redirect_to root_path, alert: "Failed to sign in."
      end
    end
  end
  
  def destroy
    if signed_in?
      sign_out
      redirect_to root_path, notice: "Successfully signed out."
    else
      redirect_to root_path, alert: "You are not signed in."
    end
  end
end
