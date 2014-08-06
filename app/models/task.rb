class Task < ActiveRecord::Base

  # more to come
  VALID_CATEGORIES = %w( title description covers classification heavy\ duty )
  enum :category => VALID_CATEGORIES

  validates :category, :inclusion => VALID_CATEGORIES
  validates :name, :category, :presence => true
  # tasks in a particular category should have unique names
  validates_uniqueness_of :name, :scope => [:category]

end
