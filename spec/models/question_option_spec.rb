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

  describe "custom #additional_input= method" do
    it "works when given a symbol/string with one of the BASE_ADDITIONAL_DATATYPES" do 
      q_o = create(:question_option)
      q_o.additional_input = :image

      expect(q_o.require_no_input?).to be false
      expect(q_o.require_image?).to be true
    end

    it "works when given a any object that responds to #to_s" do 
      a = Object.new
      def a.to_s
        "short_text"
      end

      q_o = create(:question_option)
      q_o.additional_input = a

      expect(q_o.require_no_input?).to be false
      expect(q_o.require_short_text?).to be true
    end

    it "behaves normally when argument is not a BASE_ADDITIONAL_DATATYPES" do
      expect { build(:question_option).additional_input = "something invalid" }.to raise_error(ArgumentError)
    end
  end
end
