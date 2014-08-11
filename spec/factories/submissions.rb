# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :submission do
    user { build_stubbed(:user) }
    question_option { build_stubbed(:question_option) }
  end
end
