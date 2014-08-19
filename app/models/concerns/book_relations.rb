module BookRelations
  extend ActiveSupport::Concern

  included do 
    has_many :equivalencies, 
             :as => :book, 
             :foreign_key => :book_nid

    has_many :oclc_works, 
             :through => :equivalencies

    has_many :references, 
             :as => :referenced,
             :foreign_key => :referenced_nid

    has_many :submitted_instances,
             :through => :references,
             :source => :submission
  end
end