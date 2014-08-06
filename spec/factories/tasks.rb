# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do
    name "A Task"
    category { Task::VALID_CATEGORIES.sample }
    point_value 0
  end
end
