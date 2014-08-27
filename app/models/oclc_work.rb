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

  scope :having_unrenferenced_books, ->(opts = {}) {
    opts &&= opts.with_indifferent_access

    unreferenced_querries = []
    unreferenced_query_for = ->(table){ 
      model = table.to_s.classify.constantize
      "SELECT nid FROM (#{model.unreferenced(opts).to_sql}) AS unreferenced_#{table}"
    }

    only = opts[:only]

    if only.present?
      unreferenced_querries << unreferenced_query_for.(only)
    else
      [:gutenberg_books, :oclc_books].each do |table|
        unreferenced_querries << unreferenced_query_for.(table)
      end
    end

    unreferenced_join = <<-SQL
      INNER JOIN (#{unreferenced_querries.join(' UNION ')})
      AS unreferenced_books
      ON equivalencies.book_nid = unreferenced_books.nid
    SQL
    joins(:equivalencies).joins(unreferenced_join)
  }

  scope :having_books_that_are_missing, ->(attribute, opts = {}) {
    opts &&= opts.with_indifferent_access
    only = opts[:only]
    missing_querries = []
    missing_querry_for = -> (table){
      model = table.to_s.classify.constantize
      <<-SQL
        SELECT nid, #{attribute}
        FROM (#{model.missing(attribute).to_sql})
        AS missing_#{table}
      SQL
    }
    if only.present?
      missing_querries << missing_querry_for.(only)
    else
      [:gutenberg_books, :oclc_books].each do |table|
        missing_querries << missing_querry_for.(table)
      end
    end
    missing_join = <<-SQL
      INNER JOIN (#{missing_querries.join(' UNION ')})
      AS books_missing_something
      ON books_missing_something.nid = equivalencies.book_nid
    SQL
    joins(:equivalencies).joins(missing_join)
  }

  scope :having_books_that_are_not_missing, ->(attribute, opts = {}) {
    opts &&= opts.with_indifferent_access
    only = opts[:only]
    not_missing_querries = []
    not_missing_querry_for = -> (table){
      model = table.to_s.classify.constantize
      <<-SQL
        (SELECT nid, #{attribute}
        FROM (#{model.not_missing(attribute).to_sql})
        AS not_missing_#{table})
      SQL
    }
    if only.present?
      not_missing_querries << not_missing_querry_for.(only)
    else
      [:gutenberg_books, :oclc_books].each do |table|
        not_missing_querries << not_missing_querry_for.(table)
      end
    end
    not_missing_join = <<-SQL
      INNER JOIN (#{not_missing_querries.join(' UNION ')})
      AS books_not_missing_something
      ON books_not_missing_something.nid = equivalencies.book_nid
    SQL
    joins(:equivalencies).joins(not_missing_join)
  }

end
