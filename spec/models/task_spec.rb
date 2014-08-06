require 'rails_helper'

RSpec.describe Task, :type => :model do

  describe "validations" do
    context "without a name" do
      subject { build(:task, :name => nil) }
      it { should be_invalid }
    end

    context "without category" do
      subject { build(:task, :category => nil) }
      it { should be_invalid }
    end

    context "duplicated name for tasks sharing the same category" do
      before do 
        @task = create(:task)
      end

      subject { build(:task, :name => @task.name, :category => @task.category) }
      it { should be_invalid }
    end

    context "category is not in list of valid categories" do
      it "should raise an error if tries to save" do
        expect{ create(:task, :category => "something invalid") }.to raise_error
      end
    end
  end

end
