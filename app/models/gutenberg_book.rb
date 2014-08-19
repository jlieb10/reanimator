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

  include BookRelations
  include BookScopes

  def add_authors *authors
    self.authors.tap do |a|
      a.concat(*authors)
      attribute_will_change!(:authors)
    end
  end

end
