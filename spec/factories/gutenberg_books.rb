# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gutenberg_book do
    titles { Array.new(rand(1..5)){ } }    
  end
end
