class OclcBook < ActiveRecord::Base
  self.primary_key = :nid
  has_many :equivalencies, :as => :book, :foreign_key => :book_nid

  serialize :descriptions, Array
  serialize :titles      , Array
end
