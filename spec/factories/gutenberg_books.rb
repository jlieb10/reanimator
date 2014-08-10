# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gutenberg_book do
    subtitle Faker::Lorem.sentence(2)
    nid { "Gutenberg-#{rand(1..20_000)}" }
    language 'en'

    factory :filled_gutenberg_book do
      titles { Array.new(rand(1..5)){ Faker::Lorem.sentence(2) } }    
      authors { Array.new(rand(1..3)){ Faker::Name.name } }
      links { { homepage: Faker::Internet.url } }
    end

  end
end
