require 'rails_helper'

RSpec.describe QuestionOption, :type => :model do
  describe "validations" do
    context "when an option is given to the same question more than once" do
      before do
        @question = create(:question)
        @option   = create(:option)
        @q_o      = create(:question_option, :question => @question, :option => @option)
      end

      subject { build(:question_option, :question => @question, :option => @option) }
      it { should be_invalid }

    end
  end
end
