# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :option do
    value { Faker::Lorem.sentence(2) }
  end
end
