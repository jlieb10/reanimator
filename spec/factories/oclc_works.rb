# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :oclc_work do
    nid { "owi-#{rand(1..20_000)}" }
  end
end
