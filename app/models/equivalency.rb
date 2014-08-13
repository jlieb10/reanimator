class Equivalency < ActiveRecord::Base
  # ----------------------------------------------------------
  # | id | oclc_work_nid | book_type | book_nid | confidence |
  # ----------------------------------------------------------
  
  belongs_to :oclc_work, :foreign_key => :oclc_work_nid
  belongs_to :book, polymorphic: true, :foreign_key => :book_nid

  
end
