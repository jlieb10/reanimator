class Equivalency < ActiveRecord::Base
  belongs_to :oclc_work, :foreign_key => :oclc_work_nid
  belongs_to :book, polymorphic: true, :foreign_key => :book_nid
end
