require 'rails_helper'

RSpec.describe Question, :type => :model do

  describe "validations" do 
    context "without content" do
      subject { build(:question, :content => nil) }
      it { should be_invalid }
    end

    context "without a task" do
      subject { build(:question, :task => nil) }
      it { should be_invalid }
    end

    context "without an expectation" do
      subject { build(:question, :expectation => nil) }
      it { should be_invalid }
    end

    context "with an invalid expectation" do
      it "should be invalid" do
        expect { build(:question, :expectation => "something weird") }.to raise_error(ArgumentError)
      end
    end
  end

  describe "custom #expectation= method" do
    it "works with assigned a symbol with the base part of the expectation" do
      question = build(:question)
      question.expectation = :radio

      expect(question.expects_none?).to be false
      expect(question.expects_radio?).to be true
    end

    it "works with anything that responds to #to_s" do
      a = Object.new
      def a.to_s
        "checkbox"
      end
      question = build(:question)
      question.expectation = a
      expect(question.expects_none?).to be false
      expect(question.expects_checkbox?).to be true
    end

    it "behaves normally when the argument is not one of the BASE expectations" do
      question = build(:question)
      expect { question.expectation = "something weird" }.to raise_error(ArgumentError)
    end
  end

end
