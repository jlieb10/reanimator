require 'rails_helper'

RSpec.describe User, :type => :model do
  
  describe "validations" do
    context "without a name" do
      subject{ build(:user, :name => nil) }
      it { should be_invalid }
    end

    context "withou an email" do
      subject { build(:user, :email => nil) }
      it { should be_invalid }
    end

    context "without a provider" do
      subject { build(:user, :provider => nil) }
      it { should be_invalid }
    end

    context "duplicated emails" do
      before do
        @duplicated_email = Faker::Internet.email
        create(:user, :email => @duplicated_email)
      end
      subject { build(:user, :email => @duplicated_email) }
      it { should be_invalid }
    end
  end

end
