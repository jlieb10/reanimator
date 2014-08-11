class OclcWork < ActiveRecord::Base
  # -------
  # | nid |
  # -------

  # We are using the library's id's to identify these records
  # this also applies to the way we establish relationships
  # between models
  self.primary_key =      :nid
  validates_uniqueness_of :nid

  has_many :equivalencies, 
           :foreign_key => :oclc_work_nid

  has_many :gutenberg_books, 
           :through => :equivalencies, 
           :source_type => GutenbergBook, 
           :source => :book

  has_many :oclc_books, 
           :through => :equivalencies, 
           :source_type => OclcBook, 
           :source => :book


  scope :having_gutenberg_books, ->(min = 1) {
    joins(:gutenberg_books).group('"oclc_works"."nid"').having("COUNT(gutenberg_books.nid) >= #{min}")
  }

  scope :having_oclc_books, ->(min = 1) {
    joins(:oclc_books).group('"oclc_works"."nid"').having("COUNT(oclc_books.nid) >= #{min}")    
  }


end
