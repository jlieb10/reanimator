# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :submission do
    user { build_stubbed(:user) }
    question { build_stubbed(:question) }
    option { build_stubbed(:option) }
  end
end
