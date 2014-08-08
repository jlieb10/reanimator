class Option < ActiveRecord::Base
  validates :value, :presence => true
end
