class Option < ActiveRecord::Base
  # ----------------------------------------
  # | id | value | created_at | updated_at |
  # ----------------------------------------

  validates :value, 
            :presence => true, 
            :uniqueness => true

  has_many :question_options
  has_many :questions, 
           :through => :question_options

end
