module BookScopes
  extend ActiveSupport::Concern
  
  included do
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
  end

end