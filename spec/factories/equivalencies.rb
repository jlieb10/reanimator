# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :equivalency do
    book { build_stubbed([:oclc_book, :gutenberg_book].sample) }
    oclc_work { build_stubbed(:oclc_work) }
    confidence { rand.round(1) }
  end
end
