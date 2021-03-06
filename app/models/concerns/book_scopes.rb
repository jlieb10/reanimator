module BookScopes

  extend ActiveSupport::Concern
  
  included do
    
    scope :simple_join, ->(table, opts={ on: nil }) {
      # - uses primary key by default
      # - this is to avoid using active record joins which
      # create a table alias for polymorphic relations
      # ei.joins(:equivalencies) creates "equivalencies_gutenberg_books"
      # for gutenberg_books
      on = opts.with_indifferent_access[:on]
      join = <<-SQL
        INNER JOIN "#{table}"
        ON "#{table}"."#{on}" = "#{table_name}"."#{primary_key}"
      SQL
      joins(join)
    }

    scope :missing, ->(column, block = nil) {
      unless column_names.include? column.to_s
        raise ArgumentError, "#{column} is not a column in #{table_name}"
      end

      psql_column = columns_hash[column.to_s]
      arel_column = arel_table[column]

      if psql_column.array
        # if column is array
        array_upper = Arel::Nodes::NamedFunction.new("ARRAY_UPPER", [arel_column, 1])

        query = array_upper.eq(nil)
      elsif psql_column.type == :hstore
        # if column is hash
        a_keys      = Arel::Nodes::NamedFunction.new("AKEYS", [arel_column])
        array_upper = Arel::Nodes::NamedFunction.new("ARRAY_UPPER", [a_keys, 1])

        query = array_upper.eq(nil)
      else
        query = arel_column.eq(nil)
      end

      query = block ? block.call(query) : query

      where(query)
    }

    scope :not_missing, ->(column) {
      missing(column, ->(query) { query.not })
    }

    scope :referenced, ->(opts = {}) {
      user, question, role = BookScopes.assert_and_return_valid_keys(opts, :user, :question, :role)

      submissions = Submission.arel_table
      references = Reference.arel_table

      joins(:submitted_instances)
        .where(submissions[:user_id].eq(user.id))
        .where(submissions[:question_id].eq(question.id))
        .where(references[:role].eq(role))
    }


    scope :unreferenced, ->(opts = {}) {
      user, question, role = BookScopes.assert_and_return_valid_keys(opts, :user, :question, :role)

      submissions = Submission.arel_table
      references  = Reference.arel_table
      books       = self.arel_table
      outer_join  = Arel::Nodes::OuterJoin

      join = books.join(references, outer_join)
                     .on(references[:referenced_nid].eq(books[:nid])
                     .and(references[:referenced_type].eq(self.name)))
                  .join_sources
                  # .join(submissions, outer_join)
                  #    .on(references[:submission_id].eq(submissions[:id]))

      where_clauses = []
      where_clauses << joins(join).where(references[:referenced_nid].eq(nil))
      where_clauses << joins(:submitted_instances).where(submissions[:user_id].not_eq(user.id))
      where_clauses << joins(:submitted_instances).where(submissions[:user_id]
                          .eq(user.id)
                          .and(submissions[:question_id]
                            .not_eq(question.id)))

      where_clauses << joins(:submitted_instances).where(submissions[:user_id]
                          .eq(user.id)
                          .and(submissions[:question_id]
                            .eq(question.id)
                            .and(references[:role].not_eq(role.to_s.singularize))))

      
      query = where_clauses.map(&:to_sql).join(' UNION ')
      from("(#{query}) AS \"#{table_name}\"")
    }

    scope :having_works, -> {
      equivalencies = Equivalency.arel_table
      books         = self.arel_table
      outer_join    = Arel::Nodes::OuterJoin

      join = books.join(equivalencies, outer_join)
               .on(equivalencies[:book_nid].eq(books[:nid]))
             .join_sources

      joins(join).where(equivalencies[:book_nid].not_eq(nil)).uniq
    }

    scope :sharing_works, ->(scopes = {}, group_method = "INTERSECT"){
      scopes &&= scopes.with_indifferent_access

      querries = [ OclcWork.all.to_sql ] + scopes.map do |(scope, args)|
        args = [args].flatten
        OclcWork.send(scope, *args).to_sql
      end 

      join = <<-SQL
        INNER JOIN (#{querries.join(" #{group_method} ")})
        AS grouped_oclc_works
        ON grouped_oclc_works.nid = equivalencies.oclc_work_nid
      SQL
      joins(join)
    }

    scope :sharing_works_with_unreferenced_books, ->(opts = {}) {
      # needs to join equivalencies

      join = <<-SQL
        INNER JOIN (#{OclcWork.having_unrenferenced_books(opts).to_sql})
        AS works_with_unreferenced_books
        ON works_with_unreferenced_books.nid = equivalencies.oclc_work_nid
      SQL
      joins(join)
    }

    scope :sharing_works_with_books_not_missing, -> (attribute, opts = {}) {
      join = <<-SQL
        INNER JOIN (#{OclcWork.having_books_that_are_not_missing(attribute, opts).to_sql})
        AS works_with_books_not_missing
        ON works_with_books_not_missing.nid = equivalencies.oclc_work_nid
      SQL

      joins(join)
    }

    scope :in_same_work_as, ->(book) {
      oclc_works = OclcWork.arel_table

      if (work_nids = book.oclc_works.pluck(:nid)).any?
        joins(:oclc_works)
          .where(oclc_works[:nid].in(work_nids))
          .where.not(:nid => book.nid)
      else
        none
      end
    }

    scope :having_different, ->(attribute, opts = {}) {
      as = opts.with_indifferent_access[:as]

      lowercase_function = Arel::Nodes::NamedFunction.new('LOWER', [arel_table[attribute]])

      attribute_value = as.send(attribute).downcase

      where(lowercase_function.not_eq(attribute_value))
    }

    scope :with_inconsistent_titles, ->{
      # must join equivalencies
      works_having_books_with_inconsistent_titles = OclcWork.having_books_with_inconsistent_titles.to_sql
      join = <<-SQL
        INNER JOIN (#{works_having_books_with_inconsistent_titles})
        AS "works_with_inconsistent_books"
        ON "works_with_inconsistent_books"."nid" = "equivalencies"."oclc_work_nid"
      SQL
      joins(join)
    }

  end

  class << self
    def assert_and_return_valid_keys(hash, *valid_keys)
      # hash.with_indifferent_access.assert_valid_keys(*valid_keys)
      valid_keys.map do |k| 
        hash.with_indifferent_access.fetch(k) { |name| raise ArgumentError, "Missing key: #{name}" } 
      end
    end
  end

end