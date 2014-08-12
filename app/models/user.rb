class User < ActiveRecord::Base
  # --------------------------------------------------------------------------------
  # | id | email | name | image_url | provider | auth_id | created_at | updated_at |
  # --------------------------------------------------------------------------------

  has_many :submissions

  validates_uniqueness_of :email
  validates_presence_of   :email, :name, :provider

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
