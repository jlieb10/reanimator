class Option < ActiveRecord::Base
  validates :value, :presence => true, :uniqueness => true

end
