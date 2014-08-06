class SessionsController < ApplicationController

  def create
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sessions[:user_id] = @user.id
      redirect_to root_path, notice: "Successfully signed in with Google."
    else
      redirect_to root_path, error: "Failed to sign in."
    end
  end
  
  def destroy
    sessions[:user_id] = nil

    redirect_to root_path, notice: "Successfully signed out."
  end
end
