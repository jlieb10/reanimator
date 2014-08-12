class GutenbergBook < ActiveRecord::Base
  # --------------------------------------------------------
  # | nid | titles | subtitle | authors | language | links |
  # --------------------------------------------------------

  # We are using the library's id's to identify these records
  # this also applies to the way we establish relationships
  # between models
  self.primary_key =      :nid
  validates_uniqueness_of :nid  

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

  serialize :titles , Array
  serialize :authors, Array
  serialize :links  , Hash

  include BookScopes

  scope :unreferenced, ->(opts = {}) {
    valid_keys = [:user, :question]
    opts.assert_valid_keys(*valid_keys)
    valid_keys.each { |k| opts.fetch(k) { |name| raise ArgumentError, "Missing key: #{name}" }  }

    where_values = joins(:submitted_instances).where("submissions.user_id = ?", opts[:user].id).where("submissions.question_id = ?", opts[:question].id)

    where(where_values.map(&:not).inject(&:and))
  }

end
