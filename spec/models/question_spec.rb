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
        expect { build(:question, :expectation => "something weird") }.to raise_error
      end
    end
  end

end
