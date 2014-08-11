# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :oclc_book do
    
    nid { "OCLC-#{rand(1..20_000)}" }
    language "en"

    factory :filled_oclc_book do 
      titles { Array.new(rand(1..5)){ Faker::Lorem.sentence(2) } }    
      descriptions { Array.new(rand(1..5)){ Faker::Lorem.sentence(7) } }
    end
  end
end
