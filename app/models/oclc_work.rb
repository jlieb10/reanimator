class OclcWork < ActiveRecord::Base
  # We are using the library's id's to identify these records
  # this also applies to the way we establish relationships
  # between models
  self.primary_key = :nid

  has_many :equivalencies, :foreign_key => :oclc_work_nid

end
