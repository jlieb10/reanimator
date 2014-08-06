class User < ActiveRecord::Base

  validates_uniqueness_of :email
  validates :email, :name, :provider, :presence => true

  def self.from_omniauth(auth)
    iauth = auth.with_indifferent_access
    where(:email => iauth[:info][:email]).first_or_create do |u|
      u.auth_id   = iauth[:uid]
      u.name      = iauth[:info][:name]
      u.image_url = iauth[:info][:image]
      u.provider  = iauth[:provider]
    end
  end
end
