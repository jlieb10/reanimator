class SessionsController < ApplicationController
  def create
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in(@user)
      redirect_to root_path, notice: "Successfully signed in with Google."
    else
      redirect_to root_path, error: "Failed to sign in."
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path, notice: "Successfully signed out."
  end
end
