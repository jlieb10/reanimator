class QuestionConstructor

  module Strategy

    class Base
        
      attr_reader :references

      def initialize(user, question, references)
        @user = user
        @question = question
        @references = references
      end

      def generate_references
        strategy = self
        self.class.instance_variable_get(:@defined_references).each do |role, block|
          @references[role] = ReferenceDefinition.define(role, strategy, @user, @question, &block)
        end
      end

      private

      def self.define_reference(role = :reference, &block) 
        instance_exec(role, block) do |ref_role, ref_block|
          @defined_references ||= {}
          @defined_references[ref_role] = ref_block
        end
      end

    end
  end
end