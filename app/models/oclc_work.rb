class OclcWork < ActiveRecord::Base
  self.primary_key = :nid

  has_many :equivalencies, :foreign_key => :oclc_work_nid

end
