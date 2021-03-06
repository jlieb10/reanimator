module SessionsHelper
  def sign_in_path
    "/auth/google"
  end

  def session_btn
    if signed_in?
      link_to "Sign Out", sign_out_path, :class => "small session", :method => :delete
    else
      link_to "Sign in with Google", sign_in_path, :class => "small session", :method => :post
    end
  end
end
