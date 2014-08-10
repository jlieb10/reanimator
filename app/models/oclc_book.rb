class OclcBook < ActiveRecord::Base
  # We are using the library's id's to identify these records
  # this also applies to the way we establish relationships
  # between models
  self.primary_key = :nid
  
  has_many :equivalencies, :as => :book, :foreign_key => :book_nid

  serialize :descriptions, Array
  serialize :titles      , Array
end
