class Reference < ActiveRecord::Base
  # ------------------------------------------------------------------------------
  # | id | role | referenced_type | referenced_nid | column_name | submission_id |
  # ------------------------------------------------------------------------------
  
  belongs_to :submission
  
  belongs_to :referenced, 
             :polymorphic => true, 
             :foreign_key => :referenced_nid


  validates_uniqueness_of :submission_id, :scope => [:referenced_nid, :referenced_type, :role, :column_name]
end
