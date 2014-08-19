class OclcWork < ActiveRecord::Base
  # -------
  # | nid |
  # -------

  # We are using the library's id's to identify these records
  # this also applies to the way we establish relationships
  # between models
  self.primary_key =      :nid
  validates_uniqueness_of :nid

  has_many :equivalencies, 
           :foreign_key => :oclc_work_nid

  has_many :gutenberg_books, 
           :through => :equivalencies, 
           :source_type => GutenbergBook, 
           :source => :book

  has_many :oclc_books, 
           :through => :equivalencies, 
           :source_type => OclcBook, 
           :source => :book

  scope :having_books_with_inconsistent_titles, -> {
    from = <<-SQL
          (SELECT 
            oclc_works.nid as work_nid,
            LOWER("title") as title
          FROM oclc_books
          INNER JOIN equivalencies ON equivalencies.book_nid = oclc_books.nid
          INNER JOIN oclc_works ON equivalencies.oclc_work_nid = oclc_works.nid
          GROUP BY work_nid, title
        UNION
          SELECT
            oclc_works.nid as work_nid,
            LOWER("title") as title
          FROM gutenberg_books
          INNER JOIN equivalencies ON equivalencies.book_nid = gutenberg_books.nid
          INNER JOIN oclc_works ON equivalencies.oclc_work_nid = oclc_works.nid
          GROUP BY work_nid, title) 
        AS books
    SQL

    join = <<-SQL
      INNER JOIN oclc_works ON books.work_nid = oclc_works.nid
    SQL

    self.from(from)
        .joins(join)
        .group(:nid)
        .having("COUNT(books.title) > 1")
  }

  scope :having_atleast_equivalencies, ->(count = 2) {
    # having atleast 2 or blank equivalencies
    joins(:equivalencies)
    .group('"oclc_works"."nid"')
    .having(["COUNT(\"equivalencies\") > ?", count - 1])
  }

end
