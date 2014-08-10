class Reference < ActiveRecord::Base
  # -----------------------------------------------------------------------
  # | id | referenced_type | referenced_nid | column_name | submission_id |
  # -----------------------------------------------------------------------
  
  belongs_to :submission
  belongs_to :referenced, :polymorphic => true, :foreign_key => :referenced_nid
end
