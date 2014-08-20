class OclcBook < ActiveRecord::Base
  # ------------------------------------------
  # | nid | titles | descriptions | language |
  # ------------------------------------------


  # We are using the library's id's to identify these records
  # this also applies to the way we establish relationships
  # between models
  self.primary_key =      :nid
  validates_uniqueness_of :nid

  include BookRelations
  include BookScopes

  def add_descriptions *descriptions
    self.descriptions.concat(descriptions).tap do
      attribute_will_change!(:descriptions)
    end
  end
end
