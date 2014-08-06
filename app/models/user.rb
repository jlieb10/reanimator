class User < ActiveRecord::Base

  def self.from_omniauth(auth)
    # where(auth.slice(:))
  end
end
