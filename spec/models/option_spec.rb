require 'rails_helper'

RSpec.describe Option, :type => :model do
  describe "validations" do
    context "without a value" do

      subject { build(:option, :value => nil) }
      it { should be_invalid }
    end
  end
end
