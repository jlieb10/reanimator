class Reference < ActiveRecord::Base
  belongs_to :referenced, :polymorphic => true, :foreign_key => :referenced_nid
end
