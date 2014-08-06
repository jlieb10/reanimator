class User < ActiveRecord::Base
  validates :email, :name, :presence

  def self.from_omniauth(auth)

    where(:email => auth["email"]).first_or_create.tap do |u|

    end
  end
end
