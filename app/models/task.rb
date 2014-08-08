class Task < ActiveRecord::Base

  # more to come
  VALID_CATEGORIES = %w( Title Description Covers Classification Heavy\ Duty )
  enum :category => VALID_CATEGORIES

  validates :category, :inclusion => VALID_CATEGORIES
  validates :name, :category, :presence => true
  # tasks in a particular category should have unique names
  validates_uniqueness_of :name, :scope => [:category]

  has_many :questions

  accepts_nested_attributes_for(:questions)
end
