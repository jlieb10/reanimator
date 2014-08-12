module BookScopes
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

    scope :missing, ->(column) {
      unless column_names.include? column.to_s
        raise ArgumentError, "#{column} is not a column in #{table_name}"
      end

      empty_value = nil
      
      if serialized_attributes.key?(column.to_s)
        # if the column is serialized, it means that in the db it wont
        # be represented as NULL if its an empty value
        #   - this code takes the measure to represent it as it would be in the db
        #     by calling the #dump method of the column's serializer
        ar_column = serialized_attributes[column.to_s]
        empty_value = ar_column.dump(ar_column.load(nil))
      end
      where(arel_table[column].eq(empty_value))
    }

    scope :not_missing, ->(column) {
      where(missing(column).where_values.map(&:not).inject(&:and))
    }

    scope :referenced, ->(opts = {}) {
      valid_keys = [:user, :question]
      opts.assert_valid_keys(*valid_keys)
      valid_keys.each { |k| opts.fetch(k) { |name| raise ArgumentError, "Missing key: #{name}" }  }

      joins(:submitted_instances)
        .where(Submission.arel_table[:user_id].eq(opts[:user].id))
        .where(Submission.arel_table[:question_id].eq(opts[:question].id))
    }


    scope :unreferenced, ->(opts = {}) {
      # must refactor
      valid_keys = [:user, :question]
      opts.assert_valid_keys(*valid_keys)
      valid_keys.each { |k| opts.fetch(k) { |name| raise ArgumentError, "Missing key: #{name}" }  }

      user, question = opts[:user], opts[:question]

      submissions_table = Submission.arel_table
      references_table = Reference.arel_table
      book_table = self.arel_table

      join = book_table.join(references_table, Arel::Nodes::OuterJoin).on(
                          references_table[:referenced_nid].eq(book_table[:nid])
                          .and(references_table[:referenced_type].eq(self.name)))
                        .join(submissions_table, Arel::Nodes::OuterJoin).on(references_table[:submission_id].eq(submissions_table[:id]))
                        .join_sources

      joins(join).where('"references"."referenced_nid" ISNULL') |
      joins(join).where('"submissions"."user_id" != ?', user.id) |
      joins(join).where('"submissions"."user_id" = ? AND "submissions"."question_id" != ?', user.id, question.id)
    }

    scope :in_same_work_as, ->(book) {
      if (work_nids = book.oclc_works.pluck(:nid)).any?
        joins(:oclc_works).where('"oclc_works"."nid" IN (?)', work_nids)
      else
        none
      end
    }
  end

end