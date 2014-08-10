class OclcBook < ActiveRecord::Base
  # ------------------------------------------
  # | nid | titles | descriptions | language |
  # ------------------------------------------


  # We are using the library's id's to identify these records
  # this also applies to the way we establish relationships
  # between models
  self.primary_key =      :nid
  validates_uniqueness_of :nid  
  
  has_many :equivalencies, 
           :as => :book, 
           :foreign_key => :book_nid

  has_many :oclc_works, 
           :through => :equivalencies

  serialize :descriptions, Array
  serialize :titles      , Array


end
