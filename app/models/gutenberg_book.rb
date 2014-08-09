class GutenbergBook < ActiveRecord::Base
  self.primary_key = :nid

  has_many :equivalencies, :as => :book, :foreign_key => :book_nid

  serialize :titles , Array
  serialize :authors, Array
  serialize :links  , Hash

  
end
