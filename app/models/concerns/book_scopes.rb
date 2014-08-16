module BookScopes
  class << self
    def assert_valid_keys(hash, *valid_keys)
      hash.assert_valid_keys(*valid_keys)
      valid_keys.map do |k| 
        hash.fetch(k) { |name| raise ArgumentError, "Missing key: #{name}" } 
      end
    end
  end

  extend ActiveSupport::Concern
  
  included do
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

    scope :missing, ->(column, block = nil) {
      unless column_names.include? column.to_s
        raise ArgumentError, "#{column} is not a column in #{table_name}"
      end

      empty_value = nil
      
      if serialized_attributes.key?(column.to_s)
        # if the column is serialized, it means that in the db it wont
        # be represented as NULL if its an empty value
        #   - this code takes the measure to represent it as it would be in the db
        #     by calling the #dump method of the column's serializer
        ar_column   = serialized_attributes[column.to_s]
        empty_value = ar_column.dump(ar_column.load(nil))
      end
      clause = arel_table[column].eq(empty_value)
      clause = block.present? ? block.call(clause) : clause
      where(clause)
    }

    scope :not_missing, ->(column) {
      missing(column, ->(clause){ clause.not })
    }

    scope :referenced, ->(opts = {}) {
      BookScopes.assert_valid_keys(opts, :user, :question)

      submissions = Submission.arel_table

      joins(:submitted_instances)
        .where(submissions[:user_id].eq(opts[:user].id))
        .where(submissions[:question_id].eq(opts[:question].id))
    }


    scope :unreferenced, ->(opts = {}) {
      user, question, role = BookScopes.assert_valid_keys(opts, :user, :question, :role)

      submissions = Submission.arel_table
      references  = Reference.arel_table
      books       = self.arel_table
      outer_join  = Arel::Nodes::OuterJoin

      join = books.join(references, outer_join)
                     .on(references[:referenced_nid].eq(books[:nid])
                     .and(references[:referenced_type].eq(self.name)))
                  .join(submissions, outer_join)
                     .on(references[:submission_id].eq(submissions[:id]))
                  .join_sources

      where_clauses = []
      where_clauses << references[:referenced_nid].eq(nil)
      where_clauses << submissions[:user_id].not_eq(user.id)
      where_clauses << submissions[:user_id]
                          .eq(user.id)
                          .and(submissions[:question_id]
                            .not_eq(question.id)
                            .or(references[:role].not_eq(role.to_s.singularize)))

      # this is making an sql union, not a ruby union
      # using easy_union_set gem
      where_clauses.map { |clause| joins(join).where(clause) }.inject(:|)
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

    scope :sharing_works, -> {

      sub_query = OclcWork.joins(:equivalencies)
                          .having("COUNT(equivalencies) > 1")
                          .group(:nid)
                          .to_sql

      joins(<<-SQL)
       INNER JOIN "equivalencies"
       ON "equivalencies"."book_nid" = "#{table_name}"."#{primary_key}"
       AND "equivalencies"."book_type" = '#{self.name}'
       INNER JOIN (#{sub_query}) 
       AS works_with_equivalencies
       ON "equivalencies"."oclc_work_nid" = "works_with_equivalencies"."nid"
      SQL
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
  end




end