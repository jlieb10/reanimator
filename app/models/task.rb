class Task < ActiveRecord::Base
  # --------------------------------------
  # | id | category | name | point_value | 
  # --------------------------------------

  VALID_CATEGORIES = %w( Title Description Covers Classification Heavy\ Duty )
  # these enum values will translate to scopes named 
  # #in_title, #in_description, #in_covers etc.
  # and boolean helpers named #in_title?, #in_description?, #in_covers? etc.
  include EnumHandler

  enum(:category => VALID_CATEGORIES) { |c| "in_#{c.parameterize('_')}" }

  # tasks in a particular category should have unique names
  validates_presence_of   :name, :category
  validates_uniqueness_of :name, :scope => [:category]

  has_many :questions

  accepts_nested_attributes_for(:questions)

end
