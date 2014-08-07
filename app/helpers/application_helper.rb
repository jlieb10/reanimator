module ApplicationHelper
  # enable authentication methods in views
  # ei. #signed_in?, #current_user
  include SimpleAuthentication

  def session_btn
    if signed_in?
      render "partials/signinbtn"
    else
      render "partials/signoutbtn"
    end
  end

end
