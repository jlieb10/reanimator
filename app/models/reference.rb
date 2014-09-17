class Reference < ActiveRecord::Base
  # ------------------------------------------------------------------------------
  # | id | role | referenced_type | referenced_nid | column_name | submission_id |
  # ------------------------------------------------------------------------------
  
  belongs_to :submission
  
  belongs_to :referenced, 
             :polymorphic => true, 
             :foreign_key => :referenced_nid


  validates_uniqueness_of :submission_id, :scope => [:referenced_nid, :referenced_type, :role, :column_name]

  def hidden_fields(builder, id_suffix = nil, name = "references_attributes[]")
    builder.fields_for(name, self) do |r_builder|
      r_builder.hidden_field(:role, :id => "reference_role#{id_suffix}") +
      r_builder.hidden_field(:referenced_type, :id => "reference_referenced_type#{id_suffix}") +
      r_builder.hidden_field(:referenced_nid, :id => "reference_referenced_nid#{id_suffix}") +
      r_builder.hidden_field(:column_name, :id => "reference_column_name#{id_suffix}")
    end.html_safe
  end 
end
