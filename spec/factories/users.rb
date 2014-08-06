# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email(name) }
    provider 'google'
    auth_id { rand(10000..99999) }
    image_url { Faker::Internet.url('google.com', 'image.jpeg') }
  end
end
