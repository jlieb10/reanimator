class GutenbergBook < ActiveRecord::Base
  # --------------------------------------------------------
  # | nid | titles | subtitle | authors | language | links |
  # --------------------------------------------------------

  # We are using the library's id's to identify these records
  # this also applies to the way we establish relationships
  # between models
  self.primary_key =      :nid
  validates_uniqueness_of :nid  

  serialize :titles , Array
  serialize :authors, Array
  serialize :links  , Hash

  include BookScopes

end
