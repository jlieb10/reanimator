module ApplicationHelper
  # enable authentication methods in views
  # ei. #signed_in?, #current_user
  include SimpleAuthentication

  def session_btn
    if signed_in?
      link_to "Sign Out", sign_out_path, :class => "small button round", :method => :delete
    else
      link_to "Sign in with Google", sign_in_path, :class => "small button round", :method => :post
    end
  end

end
