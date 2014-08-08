# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question_option do
    question { build_stubbed(:question) }
    option { build_stubbed(:option) }
  end
end
