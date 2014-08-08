# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    content "What is this about?"
    expectation { Question::VALID_EXPECTATIONS_ENUM.sample }
    task { build_stubbed(:task) }
  end
end
