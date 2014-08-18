class GutenbergBook < ActiveRecord::Base
  store_accessor :links
  # --------------------------------------------------------
  # | nid | titles | subtitle | authors | language | links |
  # --------------------------------------------------------

  # We are using the library's id's to identify these records
  # this also applies to the way we establish relationships
  # between models
  self.primary_key =      :nid
  validates_uniqueness_of :nid  

  # serialize :titles , Array
  # serialize :authors, Array
  # serialize :links  , ActiveRecord::Coders::Hstore

  include BookScopes

end
