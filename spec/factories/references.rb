# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reference do
    referenced { build_stubbed([:oclc_work, :gutenberg_book, :oclc_book].sample) }
    submission { build_stubbed(:submission) }
  end
end
